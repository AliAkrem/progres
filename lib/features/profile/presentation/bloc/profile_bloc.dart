import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

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
  final StudentRepositoryImpl studentRepository;
  final AuthRepositoryImpl authRepository;

  ProfileBloc({
    required this.studentRepository,
    required this.authRepository,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      // Fetch current academic year
      final academicYear = await studentRepository.getCurrentAcademicYear();

      // Fetch basic info
      final basicInfo = await studentRepository.getStudentBasicInfo();

      // Fetch detailed info
      final detailedInfo = await studentRepository.getStudentDetailedInfo(academicYear.id);

      // Fetch academic periods
      final academicPeriods = await studentRepository.getAcademicPeriods(detailedInfo.niveauId);

      // Optional data that we'll try to fetch but continue if unavailable
      String? profileImage;
      String? institutionLogo;

      try {
        profileImage = await studentRepository.getStudentProfileImage();
      } catch (e) {
        // Profile image not available, continue without it
      }

      try {
        // Get the etablissementId from auth repository
        final etablissementIdStr = await authRepository.getEtablissementId();
        if (etablissementIdStr != null) {
          final etablissementId = int.parse(etablissementIdStr);
          institutionLogo = await studentRepository.getInstitutionLogo(etablissementId);
        }
      } catch (e) {
        // Institution logo not available, continue without it
      }

      emit(ProfileLoaded(
        basicInfo: basicInfo,
        academicYear: academicYear,
        detailedInfo: detailedInfo,
        academicPeriods: academicPeriods,
        profileImage: profileImage,
        institutionLogo: institutionLogo,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
} 