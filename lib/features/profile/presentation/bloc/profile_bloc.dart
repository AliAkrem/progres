import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
  final String? profileImage;

  ProfileLoaded({
    required this.basicInfo,
    required this.academicYear,
    required this.detailedInfo,
    this.profileImage,
  });

  @override
  List<Object?> get props => [basicInfo, academicYear, detailedInfo, profileImage];
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

  ProfileBloc({required this.studentRepository}) : super(ProfileInitial()) {
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

      // Fetch profile image (optional)
      String? profileImage;
      try {
        profileImage = await studentRepository.getStudentProfileImage();
      } catch (e) {
        // Profile image not available, continue without it
      }

      emit(ProfileLoaded(
        basicInfo: basicInfo,
        academicYear: academicYear,
        detailedInfo: detailedInfo,
        profileImage: profileImage,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
} 