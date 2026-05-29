import 'package:nalargizi/core/error/failures.dart';
import '../entities/nutrition_entity.dart';
import '../repositories/nutrition_repository.dart';

/// UseCase to fetch daily nutrition summary.
class GetDailyNutritionUseCase {
  const GetDailyNutritionUseCase(this._repository);

  final NutritionRepository _repository;

  Future<({NutritionDailyEntity? data, Failure? failure})> call({
    required int childId,
    required String date,
  }) {
    return _repository.getDailyNutrition(childId: childId, date: date);
  }
}
