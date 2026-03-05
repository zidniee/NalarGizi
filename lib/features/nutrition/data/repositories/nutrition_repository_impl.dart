import '../../domain/entities/nutrition_entity.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_remote_data_source.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  const NutritionRepositoryImpl(this._remoteDataSource);

  final NutritionRemoteDataSource _remoteDataSource;

  @override
  Future<NutritionEntity> getNutritionData() {
    return _remoteDataSource.fetchNutritionData();
  }
}
