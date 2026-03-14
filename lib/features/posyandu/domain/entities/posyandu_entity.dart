import 'immunization_item_entity.dart';
import 'posyandu_schedule_item_entity.dart';

class PosyanduEntity {
  const PosyanduEntity({
    required this.immunizations,
    required this.upcomingSchedules,
    required this.completedSchedules,
  });

  final List<ImmunizationItemEntity> immunizations;
  final List<PosyanduScheduleItemEntity> upcomingSchedules;
  final List<PosyanduScheduleItemEntity> completedSchedules;

  int get completedImmunizationCount =>
      immunizations.where((item) => item.isDone).length;

  int get totalImmunizationCount => immunizations.length;
}
