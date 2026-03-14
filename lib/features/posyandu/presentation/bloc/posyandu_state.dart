import '../../domain/entities/immunization_item_entity.dart';
import '../../domain/entities/posyandu_entity.dart';
import '../../domain/entities/posyandu_schedule_item_entity.dart';

enum PosyanduStatus { initial, loading, success, failure }

class PosyanduState {
  const PosyanduState({
    this.status = PosyanduStatus.initial,
    this.message = '',
    this.data,
  });

  final PosyanduStatus status;
  final String message;
  final PosyanduEntity? data;

  List<ImmunizationItemEntity> get immunizations => data?.immunizations ?? [];

  List<PosyanduScheduleItemEntity> get upcomingSchedules =>
      data?.upcomingSchedules ?? [];

  List<PosyanduScheduleItemEntity> get completedSchedules =>
      data?.completedSchedules ?? [];

  PosyanduState copyWith({
    PosyanduStatus? status,
    String? message,
    PosyanduEntity? data,
  }) {
    return PosyanduState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
