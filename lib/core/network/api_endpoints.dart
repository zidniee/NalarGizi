/// Defines all API endpoint constants for the NalarGizi application.
///
/// Source: claude.md §3A-3G (all endpoints)
/// Source: claude1.md §FEATURE SPECIFICATION
class ApiEndpoints {
  const ApiEndpoints._();

  // Base API prefix
  static const _base = '/api';

  // ── AUTH ──────────────────────────────────────────────────────────────
  static const authLogin = '$_base/auth/login';
  static const authRegister = '$_base/auth/register';
  static const authGoogle = '$_base/auth/google';
  static const authForgotPassword = '$_base/auth/forgot-password';

  // ── DASHBOARD ─────────────────────────────────────────────────────────
  static const dashboardOverview = '$_base/dashboard/overview';

  // ── GROWTH ────────────────────────────────────────────────────────────
  static const growthRecords = '$_base/growth/records';

  // ── NUTRITION ─────────────────────────────────────────────────────────
  static const nutritionDaily = '$_base/nutrition/daily';
  static const nutritionLogs = '$_base/nutrition/logs';

  // ── POSYANDU ──────────────────────────────────────────────────────────
  static const posyanduOverview = '$_base/posyandu/overview';
  static const posyanduSchedule = '$_base/posyandu/schedule';

  /// Returns the endpoint for marking a schedule as completed.
  /// PATCH /api/posyandu/schedule/:id/complete
  static String posyanduScheduleComplete(String scheduleId) =>
      '$_base/posyandu/schedule/$scheduleId/complete';

  // ── PROFILE ───────────────────────────────────────────────────────────
  static const profileInfo = '$_base/profile/info';
  static const profileHistory = '$_base/profile/history';
  static const profileNotifications = '$_base/profile/notifications';

  // ── SYNC ──────────────────────────────────────────────────────────────
  static const sync = '$_base/v1/sync';
}