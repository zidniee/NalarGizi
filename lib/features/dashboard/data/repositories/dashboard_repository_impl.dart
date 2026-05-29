import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

/// Concrete implementation of [DashboardRepository].
///
/// Source: claude2.md §2 — Repository catches Exception → Failure
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remoteDataSource);

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<({DashboardOverviewEntity? data, Failure? failure})> getOverview({
    int childId = 1,
  }) async {
    try {
      final model = await _remoteDataSource.getOverview(childId: childId);
      return (data: model.toEntity(), failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }
}
