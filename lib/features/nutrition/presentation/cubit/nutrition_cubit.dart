import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_daily_nutrition_usecase.dart';
import '../../domain/usecases/add_meal_log_usecase.dart';
import 'nutrition_state.dart';

/// Cubit managing nutrition journal loading and addition.
class NutritionCubit extends Cubit<NutritionState> {
  final GetDailyNutritionUseCase _getDailyNutritionUseCase;
  final AddMealLogUseCase _addMealLogUseCase;

  NutritionCubit({
    required GetDailyNutritionUseCase getDailyNutritionUseCase,
    required AddMealLogUseCase addMealLogUseCase,
  })  : _getDailyNutritionUseCase = getDailyNutritionUseCase,
        _addMealLogUseCase = addMealLogUseCase,
        super(NutritionState(
          selectedDate: DateTime.now().toIso8601String().split('T')[0],
        ));

  /// Loads daily nutrition summary.
  Future<void> loadDailyNutrition({int childId = 1, String? date}) async {
    final targetDate = date ?? state.selectedDate;
    emit(state.copyWith(status: NutritionStatus.loading, selectedDate: targetDate));

    final result = await _getDailyNutritionUseCase(childId: childId, date: targetDate);

    if (result.failure != null) {
      emit(state.copyWith(
        status: NutritionStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      emit(state.copyWith(
        status: NutritionStatus.success,
        dailyData: result.data,
      ));
    }
  }

  /// Adds a new meal log and reloads summary.
  Future<void> addMealLog({
    required int childId,
    required String mealTime,
    required String timeLabel,
    required String foodName,
    required String portion,
    required int calories,
    required String status,
  }) async {
    emit(state.copyWith(status: NutritionStatus.loading));

    final result = await _addMealLogUseCase(
      childId: childId,
      mealTime: mealTime,
      timeLabel: timeLabel,
      foodName: foodName,
      portion: portion,
      calories: calories,
      status: status,
    );

    if (result.failure != null) {
      emit(state.copyWith(
        status: NutritionStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      // Reload daily data to update calculations and meals list
      await loadDailyNutrition(childId: childId);
    }
  }
}
