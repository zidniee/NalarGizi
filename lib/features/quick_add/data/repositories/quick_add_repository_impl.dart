import '../../domain/entities/quick_add_entity.dart';
import '../../domain/repositories/quick_add_repository.dart';
import '../datasources/quick_add_remote_data_source.dart';

class QuickAddRepositoryImpl implements QuickAddRepository {
  const QuickAddRepositoryImpl(this._remoteDataSource);

  final QuickAddRemoteDataSource _remoteDataSource;

  @override
  Future<QuickAddEntity> getQuickAddData() {
    return _remoteDataSource.fetchQuickAddData();
  }
}
