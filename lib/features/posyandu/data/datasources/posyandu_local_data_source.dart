import 'package:hive/hive.dart';

import 'package:nalargizi/core/storage/hive_boxes.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../models/posyandu_schedule_item_model.dart';
import '../models/immunization_item_model.dart';

/// Local data source for posyandu schedules and immunization records.
///
/// Provides offline CRUD operations on the device's Hive database
/// and tracks sync status for background synchronization.
class PosyanduLocalDataSource {
  // ── Posyandu Schedules ───────────────────────────────────────────

  /// Returns all posyandu schedules for a given child, sorted by
  /// [scheduledAt] descending.
  Future<List<PosyanduScheduleItemModel>> getSchedules(
      String childId) async {
    final box = await Hive.openBox(HiveBoxes.posyanduSchedules);
    final schedules = <PosyanduScheduleItemModel>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['childId'] == childId && map['deletedAt'] == null) {
          schedules.add(PosyanduScheduleItemModel.fromMap(map));
        }
      }
    }

    schedules.sort((a, b) {
      return b.scheduledAt.compareTo(a.scheduledAt);
    });

    return schedules;
  }

  /// Saves or overwrites a schedule in the local cache.
  Future<void> saveSchedule(
    PosyanduScheduleItemModel schedule, {
    SyncStatus status = SyncStatus.synced,
    String? childId,
  }) async {
    final box = await Hive.openBox(HiveBoxes.posyanduSchedules);
    final data = schedule.toMap();
    data['syncStatus'] = status.name;
    if (childId != null) {
      data['childId'] = childId;
    }
    await box.put(schedule.id, data);
  }

  /// Saves a batch of schedules from the server refresh.
  Future<void> saveAllSchedules(
    List<PosyanduScheduleItemModel> schedules, {
    String? childId,
  }) async {
    final box = await Hive.openBox(HiveBoxes.posyanduSchedules);
    for (final schedule in schedules) {
      final data = schedule.toMap();
      data['syncStatus'] = SyncStatus.synced.name;
      if (childId != null) {
        data['childId'] = childId;
      }
      await box.put(schedule.id, data);
    }
  }

  /// Marks a schedule as soft-deleted locally.
  Future<void> markScheduleDeleted(String scheduleId) async {
    final box = await Hive.openBox(HiveBoxes.posyanduSchedules);
    final raw = box.get(scheduleId);
    if (raw is Map) {
      final data = Map<String, dynamic>.from(raw);
      data['deletedAt'] = DateTime.now().toIso8601String();
      data['syncStatus'] = SyncStatus.pending.name;
      await box.put(scheduleId, data);
    }
  }

  // ── Immunization Records ─────────────────────────────────────────

  /// Returns all immunization records for a child from local storage.
  Future<List<ImmunizationItemModel>> getImmunizations(
      String childId) async {
    final box = await Hive.openBox(HiveBoxes.immunizationRecords);
    final records = <ImmunizationItemModel>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['childId'] == childId && map['deletedAt'] == null) {
          records.add(ImmunizationItemModel.fromMap(map));
        }
      }
    }

    return records;
  }

  /// Saves a batch of immunization records from the server.
  Future<void> saveAllImmunizations(
    List<ImmunizationItemModel> records, {
    String? childId,
  }) async {
    final box = await Hive.openBox(HiveBoxes.immunizationRecords);
    for (final record in records) {
      final data = record.toMap();
      data['syncStatus'] = SyncStatus.synced.name;
      if (childId != null) {
        data['childId'] = childId;
      }
      await box.put(record.name, data); // keyed by name for simplicity
    }
  }
}
