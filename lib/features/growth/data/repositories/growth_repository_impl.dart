import '../../domain/entities/growth_entity.dart';
import '../../domain/repositories/growth_repository.dart';
import '../datasources/growth_remote_data_source.dart';

class GrowthRepositoryImpl implements GrowthRepository {
  const GrowthRepositoryImpl(this._remoteDataSource);

  final GrowthRemoteDataSource _remoteDataSource;

  @override
  Future<GrowthEntity> getGrowthData() {
    return _remoteDataSource.fetchGrowthData();
  }
}
