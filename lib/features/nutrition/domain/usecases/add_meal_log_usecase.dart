import 'package:nalargizi/core/error/failures.dart';
import '../entities/nutrition_entity.dart';
import '../repositories/nutrition_repository.dart';

/// UseCase to log a new meal entry.
class AddMealLogUseCase {
  const AddMealLogUseCase(this._repository);

  final NutritionRepository _repository;

  Future<({NutritionMealEntity? data, Failure? failure})> call({
    required int childId,
    required String mealTime,
    required String timeLabel,
    required String foodName,
    required String portion,
    required int calories,
    required String status,
  }) {
    return _repository.addMealLog(
      childId: childId,
      mealTime: mealTime,
      timeLabel: timeLabel,
      foodName: foodName,
      portion: portion,
      calories: calories,
      status: status,
    );
  }
}
