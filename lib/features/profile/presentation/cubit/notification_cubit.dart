import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_state.dart';

/// Cubit managing system notifications.
class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationCubit(this._getNotificationsUseCase)
      : super(const NotificationState());

  /// Loads system notifications feed.
  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await _getNotificationsUseCase();

    if (result.failure != null) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: result.data ?? [],
      ));
    }
  }

  /// Marks a specific notification as read.
  Future<void> markAsRead(int id) async {
    final updatedNotifications = state.notifications.map((n) {
      if (n.id == id) {
        return NotificationEntity(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
        );
      }
      return n;
    }).toList();

    emit(state.copyWith(notifications: updatedNotifications));

    try {
      final dio = GetIt.I<Dio>();
      await dio.patch('/api/profile/notifications/$id/read');
    } catch (e) {
      debugPrint('Gagal menyelaraskan status baca: $e');
    }
  }
}

