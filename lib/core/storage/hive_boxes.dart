/// Centralized Hive box name constants and initialization helper.
///
/// All offline-first feature data is persisted in Hive boxes using
/// these standardized names to avoid typos and ensure consistency.
class HiveBoxes {
  HiveBoxes._();

  // ── Box Names ──────────────────────────────────────────────────────
  static const String children = 'children_box';
  static const String growthRecords = 'growth_records_box';
  static const String nutritionJournals = 'nutrition_journals_box';
  static const String nutritionMeals = 'nutrition_meals_box';
  static const String hydrationLogs = 'hydration_logs_box';
  static const String posyanduSchedules = 'posyandu_schedules_box';
  static const String immunizationRecords = 'immunization_records_box';
  static const String syncQueue = 'sync_queue_box';

  // ── Auth / Settings ────────────────────────────────────────────────
  static const String auth = 'auth_box';
  static const String settings = 'settings_box';

  /// Returns all box names that should be opened at app startup.
  static List<String> get allBoxes => [
        children,
        growthRecords,
        nutritionJournals,
        nutritionMeals,
        hydrationLogs,
        posyanduSchedules,
        immunizationRecords,
        syncQueue,
        auth,
        settings,
      ];
}
