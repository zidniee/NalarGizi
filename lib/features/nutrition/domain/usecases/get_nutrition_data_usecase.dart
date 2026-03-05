import '../entities/nutrition_entity.dart';
import '../repositories/nutrition_repository.dart';

class GetNutritionDataUseCase {
  const GetNutritionDataUseCase(this._repository);

  final NutritionRepository _repository;

  Future<NutritionEntity> call() {
    return _repository.getNutritionData();
  }
}
