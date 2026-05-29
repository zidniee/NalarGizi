import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

enum NotificationStatus { initial, loading, success, failure }

/// State containing all data needed by the Notifications screen.
class NotificationState extends Equatable {
  final NotificationStatus status;
  final String message;
  final List<NotificationEntity> notifications;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.message = '',
    this.notifications = const [],
  });

  @override
  List<Object?> get props => [status, message, notifications];

  NotificationState copyWith({
    NotificationStatus? status,
    String? message,
    List<NotificationEntity>? notifications,
  }) {
    return NotificationState(
      status: status ?? this.status,
      message: message ?? this.message,
      notifications: notifications ?? this.notifications,
    );
  }
}
