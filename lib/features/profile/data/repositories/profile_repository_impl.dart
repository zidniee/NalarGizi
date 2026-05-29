import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../datasources/notification_remote_data_source.dart';

/// Concrete implementation of [ProfileRepository].
///
/// Source: claude2.md §2 — Repository catches Exception → Failure.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource profileRemoteDataSource,
    required NotificationRemoteDataSource notificationRemoteDataSource,
  })  : _profileRemoteDataSource = profileRemoteDataSource,
        _notificationRemoteDataSource = notificationRemoteDataSource;

  final ProfileRemoteDataSource _profileRemoteDataSource;
  final NotificationRemoteDataSource _notificationRemoteDataSource;

  @override
  Future<({ProfileEntity? data, Failure? failure})> getProfileInfo() async {
    try {
      final model = await _profileRemoteDataSource.getProfileInfo();
      return (data: model, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({List<GrowthRecordEntity>? data, Failure? failure})> getChildHistory() async {
    try {
      final models = await _profileRemoteDataSource.getChildHistory();
      final entities = models.map((m) => m.toEntity()).toList();
      return (data: entities, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({List<NotificationEntity>? data, Failure? failure})> getNotifications() async {
    try {
      final models = await _notificationRemoteDataSource.getNotifications();
      return (data: models, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }
}
