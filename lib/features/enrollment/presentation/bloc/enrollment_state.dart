import 'package:equatable/equatable.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';

abstract class EnrollmentState extends Equatable {
  const EnrollmentState();

  @override
  List<Object?> get props => [];
}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentLoading extends EnrollmentState {}

class EnrollmentsLoaded extends EnrollmentState {
  final List<Enrollment> enrollments;
  final bool fromCache;

  const EnrollmentsLoaded({
    required this.enrollments,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [enrollments, fromCache];
}

class EnrollmentError extends EnrollmentState {
  final String message;

  const EnrollmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
