import 'package:equatable/equatable.dart';

abstract class DebtsEvent extends Equatable {
  const DebtsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDebts extends DebtsEvent {
  final bool forceRefresh;

  const LoadDebts({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ClearDebtsCache extends DebtsEvent {
  const ClearDebtsCache();
}
