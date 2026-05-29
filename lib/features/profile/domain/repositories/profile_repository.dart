import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';
import '../entities/profile_entity.dart';
import '../entities/notification_entity.dart';

/// Repository interface contract for Profile details, history log, and notifications.
abstract class ProfileRepository {
  /// Fetches profile details (parent & child info).
  Future<({ProfileEntity? data, Failure? failure})> getProfileInfo();

  /// Fetches full history of growth measurements for child.
  Future<({List<GrowthRecordEntity>? data, Failure? failure})> getChildHistory();

  /// Fetches notification messages.
  Future<({List<NotificationEntity>? data, Failure? failure})> getNotifications();
}
