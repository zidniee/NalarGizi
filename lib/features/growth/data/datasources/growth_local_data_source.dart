import 'package:hive/hive.dart';
import 'package:nalargizi/core/storage/hive_boxes.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../models/growth_model.dart';

/// Local data source for growth records using Hive.
///
/// Source: claude2.md §4 — Cache-Then-Network (Offline First)
/// Provides offline CRUD operations and tracks [SyncStatus] for sync manager.
class GrowthLocalDataSource {
  /// Returns all growth records for a given child from local cache,
  /// sorted by [recordedAt] descending (newest first).
  Future<List<GrowthRecordModel>> getRecords(String childId) async {
    final box = await Hive.openBox(HiveBoxes.growthRecords);
    final records = <GrowthRecordModel>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        // Match by childId and exclude soft-deleted
        if (map['child_id'].toString() == childId &&
            map['deletedAt'] == null) {
          records.add(GrowthRecordModel.fromMap(map));
        }
      }
    }

    // Sort by recordedAt descending (newest first)
    records.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return records;
  }

  /// Saves or updates a single growth record in local cache.
  Future<void> saveRecord(
    GrowthRecordModel record, {
    SyncStatus status = SyncStatus.synced,
  }) async {
    final box = await Hive.openBox(HiveBoxes.growthRecords);
    final data = record.toMap();
    data['syncStatus'] = status.name;
    await box.put(record.id.toString(), data);
  }

  /// Saves a batch of records fetched from server, overwriting local versions.
  Future<void> saveAllRecords(List<GrowthRecordModel> records) async {
    final box = await Hive.openBox(HiveBoxes.growthRecords);
    for (final record in records) {
      final data = record.toMap();
      data['syncStatus'] = SyncStatus.synced.name;
      await box.put(record.id.toString(), data);
    }
  }

  /// Marks a record as soft-deleted locally.
  Future<void> markDeleted(String recordId) async {
    final box = await Hive.openBox(HiveBoxes.growthRecords);
    final raw = box.get(recordId);
    if (raw is Map) {
      final data = Map<String, dynamic>.from(raw);
      data['deletedAt'] = DateTime.now().toIso8601String();
      data['syncStatus'] = SyncStatus.pending.name;
      await box.put(recordId, data);
    }
  }

  /// Permanently removes a record from local storage.
  Future<void> removeRecord(String recordId) async {
    final box = await Hive.openBox(HiveBoxes.growthRecords);
    await box.delete(recordId);
  }
}
