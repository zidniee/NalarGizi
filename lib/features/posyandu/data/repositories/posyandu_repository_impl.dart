import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../../domain/entities/posyandu_entity.dart';
import '../../domain/entities/posyandu_schedule_item_entity.dart';
import '../../domain/repositories/posyandu_repository.dart';
import '../datasources/posyandu_local_data_source.dart';
import '../datasources/posyandu_remote_data_source.dart';
import '../models/immunization_item_model.dart';
import '../models/posyandu_schedule_item_model.dart';

/// Concrete implementation of [PosyanduRepository].
///
/// Source: claude2.md §4 — Cache-Then-Network (Offline First) fallback.
/// Source: claude2.md §2 — Repository catches Exception → Failure.
class PosyanduRepositoryImpl implements PosyanduRepository {
  const PosyanduRepositoryImpl({
    required PosyanduRemoteDataSource remoteDataSource,
    required PosyanduLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final PosyanduRemoteDataSource _remoteDataSource;
  final PosyanduLocalDataSource _localDataSource;

  @override
  Future<({PosyanduEntity? data, Failure? failure})> getPosyanduData({
    int childId = 1,
  }) async {
    try {
      // 1. Try fetching from remote
      final remoteModel = await _remoteDataSource.fetchPosyanduData();

      // 2. Update local database cache on success
      final upcoming = remoteModel.upcomingSchedules.cast<PosyanduScheduleItemModel>();
      final completed = remoteModel.completedSchedules.cast<PosyanduScheduleItemModel>();
      await _localDataSource.saveAllSchedules(
        upcoming + completed,
        childId: childId.toString(),
      );

      final immunizations = remoteModel.immunizations.cast<ImmunizationItemModel>();
      await _localDataSource.saveAllImmunizations(
        immunizations,
        childId: childId.toString(),
      );

      return (data: remoteModel, failure: null);
    } on ServerException catch (e) {
      // 3. Fallback: try loading cache
      try {
        final cachedSchedules = await _localDataSource.getSchedules(childId.toString());
        final cachedImmunizations = await _localDataSource.getImmunizations(childId.toString());

        if (cachedSchedules.isNotEmpty || cachedImmunizations.isNotEmpty) {
          final upcoming = cachedSchedules.where((s) => !s.isCompleted).toList();
          final completed = cachedSchedules.where((s) => s.isCompleted).toList();

          return (
            data: PosyanduEntity(
              immunizations: cachedImmunizations,
              upcomingSchedules: upcoming,
              completedSchedules: completed,
            ),
            failure: null,
          );
        }
      } catch (_) {
        // ignore cache failure, fallback to returning the server failure
      }
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Failure?> markScheduleCompleted(String scheduleId) async {
    try {
      await _remoteDataSource.markScheduleCompleted(scheduleId);
      return null;
    } on ServerException catch (e) {
      return ServerFailure(e.message);
    } catch (e) {
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<Failure?> addSchedule(PosyanduScheduleItemEntity schedule) async {
    // 1. Simpan dulu ke Hive lokal sebagai pending (offline-first)
    final localModel = PosyanduScheduleItemModel(
      id: schedule.id,
      title: schedule.title,
      category: schedule.category,
      location: schedule.location,
      scheduledAt: schedule.scheduledAt,
      note: schedule.note,
      isCompleted: false,
    );
    await _localDataSource.saveSchedule(
      localModel,
      status: SyncStatus.pending,
      childId: '1',
    );

    // 2. Kirim ke server
    try {
      final savedModel = await _remoteDataSource.addSchedule(schedule);
      // 3. Update status lokal menjadi synced
      await _localDataSource.saveSchedule(
        savedModel,
        status: SyncStatus.synced,
        childId: '1',
      );
      return null;
    } on ServerException catch (e) {
      // Tetap di lokal dengan status pending; tidak hapus data lokal
      return ServerFailure(e.message);
    } catch (e) {
      return UnknownFailure(e.toString());
    }
  }
}
