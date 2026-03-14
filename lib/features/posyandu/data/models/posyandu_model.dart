import '../../domain/entities/posyandu_entity.dart';
import 'immunization_item_model.dart';
import 'posyandu_schedule_item_model.dart';

class PosyanduModel extends PosyanduEntity {
  const PosyanduModel({
    required super.immunizations,
    required super.upcomingSchedules,
    required super.completedSchedules,
  });

  factory PosyanduModel.fromMap(Map<String, dynamic> map) {
    final immunizations = (map['immunizations'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ImmunizationItemModel.fromMap)
        .toList();

    final upcoming = (map['upcoming_schedules'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(PosyanduScheduleItemModel.fromMap)
        .toList();

    final completed = (map['completed_schedules'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(PosyanduScheduleItemModel.fromMap)
        .toList();

    return PosyanduModel(
      immunizations: immunizations,
      upcomingSchedules: upcoming,
      completedSchedules: completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'immunizations': immunizations
          .whereType<ImmunizationItemModel>()
          .map((item) => item.toMap())
          .toList(),
      'upcoming_schedules': upcomingSchedules
          .whereType<PosyanduScheduleItemModel>()
          .map((item) => item.toMap())
          .toList(),
      'completed_schedules': completedSchedules
          .whereType<PosyanduScheduleItemModel>()
          .map((item) => item.toMap())
          .toList(),
    };
  }
}
