import '../../domain/entities/posyandu_entity.dart';
import '../../domain/repositories/posyandu_repository.dart';
import '../datasources/posyandu_remote_data_source.dart';

class PosyanduRepositoryImpl implements PosyanduRepository {
  const PosyanduRepositoryImpl(this._remoteDataSource);

  final PosyanduRemoteDataSource _remoteDataSource;

  @override
  Future<PosyanduEntity> getPosyanduData() {
    return _remoteDataSource.fetchPosyanduData();
  }
}
