import 'package:nalargizi/core/error/failures.dart';
import '../entities/nutrition_entity.dart';

/// Repository interface for Nutrition feature, defining all data sync operations.
abstract class NutritionRepository {
  /// Fetches daily nutrition summary for a child on a specific date.
  Future<({NutritionDailyEntity? data, Failure? failure})> getDailyNutrition({
    required int childId,
    required String date,
  });

  /// Adds a new meal log.
  Future<({NutritionMealEntity? data, Failure? failure})> addMealLog({
    required int childId,
    required String mealTime,
    required String timeLabel,
    required String foodName,
    required String portion,
    required int calories,
    required String status,
  });
}
