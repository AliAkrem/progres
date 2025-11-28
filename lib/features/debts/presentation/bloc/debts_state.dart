import 'package:equatable/equatable.dart';
import 'package:progres/features/debts/data/models/academic_year_debt.dart';

abstract class DebtsState extends Equatable {
  const DebtsState();

  @override
  List<Object?> get props => [];
}

class DebtsInitial extends DebtsState {}

class DebtsLoading extends DebtsState {}

class DebtsLoaded extends DebtsState {
  final List<AcademicYearDebt> debts;
  final bool fromCache;

  const DebtsLoaded({required this.debts, this.fromCache = false});

  @override
  List<Object?> get props => [debts, fromCache];
}

class DebtsEmpty extends DebtsState {}

class DebtsError extends DebtsState {
  final String message;

  const DebtsError({required this.message});

  @override
  List<Object?> get props => [message];
}
