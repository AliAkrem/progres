import 'package:equatable/equatable.dart';

abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadEnrollmentsEvent extends EnrollmentEvent {
  final bool forceRefresh;

  const LoadEnrollmentsEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ClearEnrollmentsCache extends EnrollmentEvent {}
