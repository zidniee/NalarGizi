import '../../domain/entities/posyandu_schedule_item_entity.dart';

class PosyanduScheduleItemModel extends PosyanduScheduleItemEntity {
  const PosyanduScheduleItemModel({
    required super.id,
    required super.title,
    required super.category,
    required super.location,
    required super.scheduledAt,
    super.note,
    super.isCompleted,
  });

  factory PosyanduScheduleItemModel.fromMap(Map<String, dynamic> map) {
    return PosyanduScheduleItemModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      note: map['note'] as String?,
      isCompleted: (map['is_completed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'scheduled_at': scheduledAt.toIso8601String(),
      'note': note,
      'is_completed': isCompleted,
    };
  }
}
