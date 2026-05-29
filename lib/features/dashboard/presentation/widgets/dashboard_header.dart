import 'package:flutter/material.dart';
import 'package:nalargizi/app/router/app_router.dart';

/// Dashboard header widget displaying child name, notification bell, and profile avatar.
///
/// Source: claude1.md §DASHBOARD Responsibilities — child name from API
/// All data passed as parameters, zero hardcoding.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.childName,
    this.posyanduScheduleCount = 0,
  });

  final String? childName;
  final int posyanduScheduleCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── Left: Avatar + Greeting ──────────────────────────────────
        Expanded(
          child: Row(
            children: [
              // Avatar — tappable → Profile page
              Tooltip(
                message: 'Buka Profil',
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.child_care,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selamat Pagi, Bunda 👋",
                    style: TextStyle(
                      color: Color(0xFFFFE4E6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    childName != null ? 'Data $childName' : 'Memuat data...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Right: Notification bell ─────────────────────────────────
        Tooltip(
          message: 'Notifikasi',
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRouter.notifications),
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (posyanduScheduleCount > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFF00),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
