import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/debts/data/services/debts_cache_service.dart';
import 'package:progres/features/debts/domain/usecases/get_student_debts.dart';
import 'package:progres/features/debts/presentation/bloc/debts_event.dart';
import 'package:progres/features/debts/presentation/bloc/debts_state.dart';

class DebtsBloc extends Bloc<DebtsEvent, DebtsState> {
  final GetStudentDebts getStudentDebts;
  final DebtsCacheService debtsCacheService;

  DebtsBloc({required this.getStudentDebts, required this.debtsCacheService})
      : super(DebtsInitial()) {
    on<LoadDebts>(_onLoadDebts);
    on<ClearDebtsCache>(_onClearCache);
  }

  Future<void> _onLoadDebts(LoadDebts event, Emitter<DebtsState> emit) async {
    try {
      emit(DebtsLoading());

      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isStale = await debtsCacheService.isDataStale();
        if (!isStale) {
          final cachedDebts = await debtsCacheService.getCachedDebts();
          if (cachedDebts != null) {
            if (cachedDebts.isEmpty) {
              emit(DebtsEmpty());
            } else {
              emit(DebtsLoaded(debts: cachedDebts, fromCache: true));
            }
            return;
          }
        }
      }

      final debts = await getStudentDebts();

      // Cache the results
      await debtsCacheService.cacheDebts(debts);

      if (debts.isEmpty) {
        emit(DebtsEmpty());
      } else {
        emit(DebtsLoaded(debts: debts, fromCache: false));
      }
    } catch (e) {
      debugPrint('Error loading debts: $e');

      final cachedDebts = await debtsCacheService.getCachedDebts();
      if (cachedDebts != null) {
        if (cachedDebts.isEmpty) {
          emit(DebtsEmpty());
        } else {
          emit(DebtsLoaded(debts: cachedDebts, fromCache: true));
        }
      } else {
        emit(DebtsError(message: e.toString()));
      }
    }
  }

  Future<void> _onClearCache(
    ClearDebtsCache event,
    Emitter<DebtsState> emit,
  ) async {
    await debtsCacheService.clearCache();
  }
}
