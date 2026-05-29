import 'package:nalargizi/core/error/failures.dart';
import '../entities/posyandu_entity.dart';
import '../entities/posyandu_schedule_item_entity.dart';

abstract class PosyanduRepository {
  Future<({PosyanduEntity? data, Failure? failure})> getPosyanduData({
    int childId,
  });

  /// Sends PATCH to mark a schedule as completed.
  /// Returns null on success, or a [Failure] on error.
  Future<Failure?> markScheduleCompleted(String scheduleId);

  /// POSTs a new posyandu schedule to the server and saves it locally.
  /// Returns null on success, or a [Failure] on error.
  Future<Failure?> addSchedule(PosyanduScheduleItemEntity schedule);
}
