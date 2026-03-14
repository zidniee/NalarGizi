class PosyanduScheduleItemEntity {
  const PosyanduScheduleItemEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.scheduledAt,
    this.note,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String category;
  final String location;
  final DateTime scheduledAt;
  final String? note;
  final bool isCompleted;

  PosyanduScheduleItemEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? location,
    DateTime? scheduledAt,
    String? note,
    bool? isCompleted,
  }) {
    return PosyanduScheduleItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
