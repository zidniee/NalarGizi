import '../entities/growth_entity.dart';
import '../repositories/growth_repository.dart';

class GetGrowthDataUseCase {
  const GetGrowthDataUseCase(this._repository);

  final GrowthRepository _repository;

  Future<GrowthEntity> call() {
    return _repository.getGrowthData();
  }
}
