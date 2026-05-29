import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nalargizi/app/layout/main_layout.dart';
import 'package:nalargizi/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:nalargizi/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/dashboard_status_row.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/edukasi_gizi_section.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/info_posyandu_banner.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/jadwal_terdekat_card.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/tip_harian_card.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/z_score_indicator_card.dart';

/// Dashboard page — main home screen of NalarGizi.
///
/// Source: claude1.md §DASHBOARD Responsibilities
/// Source: claude2.md §3 — BlocProvider + GetIt.I<DashboardCubit>()
/// Source: claude1.md §UI RULES — Loading, Empty, Error, Success states
/// Source: claude1.md §96 — No business logic in pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<DashboardCubit>()..loadOverview(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: 0,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return ColoredBox(
            color: Colors.grey.shade50,
            child: switch (state.status) {
              // ── Loading state (claude1.md §387 — Skeleton Loading) ──
              DashboardStatus.loading || DashboardStatus.initial =>
                const _DashboardSkeleton(),

              // ── Error state (claude1.md §388 — Error Retry) ──
              DashboardStatus.failure => _DashboardError(
                  message: state.message,
                  onRetry: () =>
                      context.read<DashboardCubit>().retry(),
                ),

              // ── Success & Empty states ──
              DashboardStatus.success ||
              DashboardStatus.empty => _DashboardContent(state: state),
            },
          );
        },
      ),
    );
  }
}

/// The actual dashboard content — driven entirely by DashboardState.
class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final overview = state.overview;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header gradient section ──
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 32,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                DashboardHeader(
                  childName: overview?.childInfo.name,
                  posyanduScheduleCount:
                      overview?.nearestSchedule != null ? 1 : 0,
                ),
                const SizedBox(height: 24),
                DashboardStatusRow(
                  weightKg: overview?.lastGrowth.weightKg,
                  ageMonths: overview?.childInfo.ageMonths,
                  zScoreStatus: overview?.lastGrowth.zScoreStatus,
                ),
              ],
            ),
          ),

          // ── Content section ──
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TipHarianCard(
                  title: overview?.dailyTip.title,
                  content: overview?.dailyTip.content,
                ),
                const SizedBox(height: 20),
                ZScoreIndicatorCard(
                  zScoreStatus: overview?.lastGrowth.zScoreStatus,
                  weightKg: overview?.lastGrowth.weightKg,
                  heightCm: overview?.lastGrowth.heightCm,
                ),
                const SizedBox(height: 20),
                JadwalTerdekatCard(
                  schedule: overview?.nearestSchedule,
                ),
                const SizedBox(height: 24),
                EdukasiGiziSection(
                  contents: overview?.educationalContents ?? [],
                ),
                const SizedBox(height: 24),
                InfoPosyanduBanner(
                  center: overview?.posyanduCenter,
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loading placeholder per claude1.md §387.
class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header skeleton
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state with retry per claude1.md §388.
class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              key: const Key('dashboard_retry_btn'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF43F5E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
