import 'package:hive/hive.dart';

import 'package:nalargizi/core/storage/hive_boxes.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../models/nutrition_model.dart';

/// Local data source for nutrition journals, meals, and hydration logs.
///
/// Uses Hive for offline persistence of all nutrition-related data.
class NutritionLocalDataSource {
  // ── Journals ─────────────────────────────────────────────────────

  Future<List<NutritionJournalModel>> getJournals(String childId) async {
    final box = await Hive.openBox(HiveBoxes.nutritionJournals);
    final journals = <NutritionJournalModel>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['childId'] == childId && map['deletedAt'] == null) {
          journals.add(NutritionJournalModel.fromMap(map));
        }
      }
    }

    journals.sort((a, b) => b.journalDate.compareTo(a.journalDate));
    return journals;
  }

  Future<void> saveJournal(NutritionJournalModel journal,
      {SyncStatus status = SyncStatus.synced}) async {
    final box = await Hive.openBox(HiveBoxes.nutritionJournals);
    final data = journal.toMap();
    data['syncStatus'] = status.name;
    await box.put(journal.id, data);
  }

  Future<void> saveAllJournals(List<NutritionJournalModel> journals) async {
    final box = await Hive.openBox(HiveBoxes.nutritionJournals);
    for (final journal in journals) {
      final data = journal.toMap();
      data['syncStatus'] = SyncStatus.synced.name;
      await box.put(journal.id, data);
    }
  }

  // ── Meals ────────────────────────────────────────────────────────

  Future<List<NutritionMealModel>> getMeals(String journalId) async {
    final box = await Hive.openBox(HiveBoxes.nutritionMeals);
    final meals = <NutritionMealModel>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['nutritionJournalId'] == journalId &&
            map['deletedAt'] == null) {
          meals.add(NutritionMealModel.fromMap(map));
        }
      }
    }

    return meals;
  }

  Future<void> saveMeal(NutritionMealModel meal,
      {SyncStatus status = SyncStatus.synced}) async {
    final box = await Hive.openBox(HiveBoxes.nutritionMeals);
    final data = meal.toMap();
    data['syncStatus'] = status.name;
    await box.put(meal.id, data);
  }

  Future<void> markMealDeleted(String mealId) async {
    final box = await Hive.openBox(HiveBoxes.nutritionMeals);
    final raw = box.get(mealId);
    if (raw is Map) {
      final data = Map<String, dynamic>.from(raw);
      data['deletedAt'] = DateTime.now().toIso8601String();
      data['syncStatus'] = SyncStatus.pending.name;
      await box.put(mealId, data);
    }
  }

  // ── Hydration ────────────────────────────────────────────────────

  Future<HydrationLogModel?> getTodayHydration(String childId) async {
    final box = await Hive.openBox(HiveBoxes.hydrationLogs);
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['childId'] == childId && map['deletedAt'] == null) {
          final logDate = (map['logDate'] as String).split('T')[0];
          if (logDate == todayStr) {
            return HydrationLogModel.fromMap(map);
          }
        }
      }
    }
    return null;
  }

  Future<void> saveHydration(HydrationLogModel log,
      {SyncStatus status = SyncStatus.synced}) async {
    final box = await Hive.openBox(HiveBoxes.hydrationLogs);
    final data = log.toMap();
    data['syncStatus'] = status.name;
    await box.put(log.id, data);
  }
}
