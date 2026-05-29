import 'package:equatable/equatable.dart';

/// Entity representing a single notification entry.
class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type, // e.g. 'posyandu', 'growth'
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  @override
  List<Object?> get props => [id, title, message, type, isRead, createdAt];
}
