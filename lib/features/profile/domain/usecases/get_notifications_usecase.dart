import 'package:nalargizi/core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase to retrieve notification feed messages.
class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<({List<NotificationEntity>? data, Failure? failure})> call() {
    return _repository.getNotifications();
  }
}
