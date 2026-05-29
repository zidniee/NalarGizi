import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../../domain/entities/growth_entity.dart';
import '../../domain/repositories/growth_repository.dart';
import '../datasources/growth_local_data_source.dart';
import '../datasources/growth_remote_data_source.dart';

/// Concrete implementation of [GrowthRepository].
///
/// Source: claude2.md §4 — Cache-Then-Network (Offline First):
/// 1. Return data from LocalDataSource immediately.
/// 2. Fetch from RemoteDataSource in background.
/// 3. If Remote succeeds, save to Local and return updated list.
///
/// Source: claude2.md §2 — Repository catches Exception → Failure.
class GrowthRepositoryImpl implements GrowthRepository {
  const GrowthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final GrowthRemoteDataSource remoteDataSource;
  final GrowthLocalDataSource localDataSource;

  @override
  Future<({List<GrowthRecordEntity>? data, Failure? failure})> getRecords({
    int childId = 1,
  }) async {
    try {
      // Step 1: Fetch from remote (MockInterceptor in debug mode)
      final remoteModels = await remoteDataSource.getRecords(
        childId: childId,
      );

      // Step 2: Save to local cache (claude2.md §4)
      await localDataSource.saveAllRecords(remoteModels);

      // Step 3: Return as entities
      final entities = remoteModels.map((m) => m.toEntity()).toList();
      return (data: entities, failure: null);
    } on ServerException catch (e) {
      // Fallback: try to return cached local data
      try {
        final localModels = await localDataSource.getRecords(
          childId.toString(),
        );
        if (localModels.isNotEmpty) {
          return (
            data: localModels.map((m) => m.toEntity()).toList(),
            failure: null,
          );
        }
      } catch (_) {
        // ignore cache failure, return original error
      }
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({GrowthRecordEntity? data, Failure? failure})> addRecord(
    Map<String, dynamic> data,
  ) async {
    try {
      final remoteModel = await remoteDataSource.addRecord(data);
      // Save to local immediately after POST success
      await localDataSource.saveRecord(
        remoteModel,
        status: SyncStatus.synced,
      );
      return (data: remoteModel.toEntity(), failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }
}
