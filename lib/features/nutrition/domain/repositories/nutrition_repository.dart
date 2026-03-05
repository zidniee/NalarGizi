import '../entities/nutrition_entity.dart';

abstract class NutritionRepository {
  Future<NutritionEntity> getNutritionData();
}
