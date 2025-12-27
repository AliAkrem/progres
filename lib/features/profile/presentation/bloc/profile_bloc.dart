import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/auth/domain/usecases/get_establishment_id.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';
import 'package:progres/features/profile/data/services/profile_cache_service.dart';
import 'package:progres/features/profile/domain/usecases/get_academic_periods.dart';
import 'package:progres/features/profile/domain/usecases/get_current_academic_year.dart';
import 'package:progres/features/profile/domain/usecases/get_institution_logo.dart';
import 'package:progres/features/profile/domain/usecases/get_student_basic_info.dart';
import 'package:progres/features/profile/domain/usecases/get_student_detailed_info.dart';
import 'package:progres/features/profile/domain/usecases/get_student_profile_image.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class ClearProfileCacheEvent extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final StudentBasicInfo basicInfo;
  final AcademicYear academicYear;
  final StudentDetailedInfo detailedInfo;
  final List<AcademicPeriod> academicPeriods;
  final String? profileImage;
  final String? institutionLogo;

  ProfileLoaded({
    required this.basicInfo,
    required this.academicYear,
    required this.detailedInfo,
    required this.academicPeriods,
    this.profileImage,
    this.institutionLogo,
  });

  ProfileLoaded copyWith({
    StudentBasicInfo? basicInfo,
    AcademicYear? academicYear,
    StudentDetailedInfo? detailedInfo,
    List<AcademicPeriod>? academicPeriods,
    String? profileImage,
    String? institutionLogo,
    List<Enrollment>? enrollments,
  }) {
    return ProfileLoaded(
      basicInfo: basicInfo ?? this.basicInfo,
      academicYear: academicYear ?? this.academicYear,
      detailedInfo: detailedInfo ?? this.detailedInfo,
      academicPeriods: academicPeriods ?? this.academicPeriods,
      profileImage: profileImage ?? this.profileImage,
      institutionLogo: institutionLogo ?? this.institutionLogo,
    );
  }

  @override
  List<Object?> get props => [
        basicInfo,
        academicYear,
        detailedInfo,
        academicPeriods,
        profileImage,
        institutionLogo,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetStudentBasicInfo getStudentBasicInfo;
  final GetCurrentAcademicYear getCurrentAcademicYear;
  final GetStudentDetailedInfo getStudentDetailedInfo;
  final GetStudentProfileImage getStudentProfileImage;
  final GetInstitutionLogo getInstitutionLogo;
  final GetAcademicPeriods getAcademicPeriods;
  final GetEstablishmentIdUseCase getEstablishmentId;
  final ProfileCacheService cacheService;

  ProfileBloc({
    required this.getStudentBasicInfo,
    required this.getCurrentAcademicYear,
    required this.getStudentDetailedInfo,
    required this.getStudentProfileImage,
    required this.getInstitutionLogo,
    required this.getAcademicPeriods,
    required this.getEstablishmentId,
    required this.cacheService,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<ClearProfileCacheEvent>((event, emit) async {
      await cacheService.clearCache();
    });
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // Fetch current academic year first to know which cache to check
      final academicYear = await getCurrentAcademicYear();

      // Try to load cached profile for this specific year
      final cachedProfileData = await cacheService.getCachedProfileData(
        academicYear.id,
      );
      if (cachedProfileData != null) {
        final basicInfo = StudentBasicInfo.fromJson(
          cachedProfileData['basicInfo'],
        );
        final cachedAcademicYear = AcademicYear.fromJson(
          cachedProfileData['academicYear'],
        );
        final detailedInfo = StudentDetailedInfo.fromJson(
          cachedProfileData['detailedInfo'],
        );
        final academicPeriodsJson = cachedProfileData['academicPeriods'] ?? [];
        final academicPeriods = academicPeriodsJson
            .map<AcademicPeriod>((item) => AcademicPeriod.fromJson(item))
            .toList();
        final profileImage = cachedProfileData['profileImage'] as String?;
        final institutionLogo =
            cachedProfileData['institutionLogo'] as String?;

        emit(
          ProfileLoaded(
            basicInfo: basicInfo,
            academicYear: cachedAcademicYear,
            detailedInfo: detailedInfo,
            academicPeriods: academicPeriods,
            profileImage: profileImage,
            institutionLogo: institutionLogo,
          ),
        );
      }

      emit(ProfileLoading());

      // Fetch basic info
      final basicInfo = await getStudentBasicInfo();

      // Fetch detailed info
      final detailedInfo = await getStudentDetailedInfo(
        academicYear.id,
      );

      // Fetch academic periods
      final academicPeriods = await getAcademicPeriods(
        detailedInfo.levelId,
      );

      // Optional data that we'll try to fetch but continue if unavailable
      String? profileImage;
      String? institutionLogo;

      try {
        profileImage = await getStudentProfileImage();
      } catch (e) {
        // Profile image not available, continue without it
      }

      try {
        // Get the etablissementId from auth repository
        final establishmentId = await getEstablishmentId();
        if (establishmentId != null) {
          institutionLogo = await getInstitutionLogo(
            int.parse(establishmentId),
          );
        }
      } catch (e) {
        // Institution logo not available, continue without it
      }

      // Cache latest profile data with year ID
      await cacheService.cacheProfileData({
        'basicInfo': basicInfo.toJson(),
        'academicYear': academicYear.toJson(),
        'detailedInfo': detailedInfo.toJson(),
        'academicPeriods':
            academicPeriods.map((e) => e.toJson()).toList(),
        'profileImage': profileImage,
        'institutionLogo': institutionLogo,
      }, academicYear.id);

      emit(
        ProfileLoaded(
          basicInfo: basicInfo,
          academicYear: academicYear,
          detailedInfo: detailedInfo,
          academicPeriods: academicPeriods,
          profileImage: profileImage,
          institutionLogo: institutionLogo,
        ),
      );
    } catch (e) {
      // On error, try to get academic year and fallback to cache
      try {
        final academicYear = await getCurrentAcademicYear();
        final cachedProfileData = await cacheService.getCachedProfileData(
          academicYear.id,
        );
        if (cachedProfileData != null) {
          final basicInfo = StudentBasicInfo.fromJson(
            cachedProfileData['basicInfo'],
          );
          final cachedAcademicYear = AcademicYear.fromJson(
            cachedProfileData['academicYear'],
          );
          final detailedInfo = StudentDetailedInfo.fromJson(
            cachedProfileData['detailedInfo'],
          );
          final academicPeriodsJson =
              cachedProfileData['academicPeriods'] ?? [];
          final academicPeriods = academicPeriodsJson
              .map<AcademicPeriod>((item) => AcademicPeriod.fromJson(item))
              .toList();
          final profileImage = cachedProfileData['profileImage'] as String?;
          final institutionLogo =
              cachedProfileData['institutionLogo'] as String?;

          emit(
            ProfileLoaded(
              basicInfo: basicInfo,
              academicYear: cachedAcademicYear,
              detailedInfo: detailedInfo,
              academicPeriods: academicPeriods,
              profileImage: profileImage,
              institutionLogo: institutionLogo,
            ),
          );
          return;
        }
      } catch (_) {
        // If we can't get year or cache, emit error
      }
      emit(ProfileError(e.toString()));
    }
  }
}
