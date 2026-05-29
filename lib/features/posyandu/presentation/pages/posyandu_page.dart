import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:nalargizi/app/layout/main_layout.dart';
import 'package:nalargizi/shared/widgets/posyandu_detail_bottom_sheet.dart';
import 'package:nalargizi/features/posyandu/domain/entities/immunization_item_entity.dart';
import 'package:nalargizi/features/posyandu/domain/entities/posyandu_schedule_item_entity.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_cubit.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_state.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/akan_datang_section.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/immunization_status_card.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/posyandu_header.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/riwayat_selesai_section.dart';

/// Posyandu overview and immunization page.
///
/// Source: claude2.md §3 — BlocProvider + `GetIt.I<PosyanduCubit>()`
class PosyanduPage extends StatelessWidget {
  const PosyanduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PosyanduCubit>()..load(),
      child: const _PosyanduView(),
    );
  }
}

class _PosyanduView extends StatefulWidget {
  const _PosyanduView();

  @override
  State<_PosyanduView> createState() => _PosyanduViewState();
}

class _PosyanduViewState extends State<_PosyanduView> {
  List<PosyanduScheduleItemEntity> _upcomingItems = [];
  List<PosyanduScheduleItemEntity> _historyItems = [];
  List<ImmunizationItemEntity> _immunizations = [];
  bool _seededFromApi = false;

  void _seedLocalData(PosyanduState state) {
    if (_seededFromApi ||
        state.status != PosyanduStatus.success ||
        state.data == null) {
      return;
    }

    setState(() {
      _upcomingItems = List<PosyanduScheduleItemEntity>.from(
        state.upcomingSchedules,
      );
      _historyItems = List<PosyanduScheduleItemEntity>.from(
        state.completedSchedules,
      );
      _immunizations = List<ImmunizationItemEntity>.from(state.immunizations);
      _seededFromApi = true;
    });
  }

  void _addUpcomingEvent(PosyanduScheduleItemEntity item) {
    // Optimistic UI update: tampilkan item langsung tanpa menunggu server
    setState(() {
      _upcomingItems.insert(0, item);
    });

    // Simpan ke server via cubit → repository → remote data source
    context.read<PosyanduCubit>().addSchedule(item).then((success) {
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} berhasil ditambahkan dan tersimpan!'),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Jadwal disimpan lokal, gagal mengirim ke server. Akan disinkronkan nanti.'),
            backgroundColor: Color(0xFFF59E0B),
          ),
        );
      }
    });
  }

  void _markAsCompleted(PosyanduScheduleItemEntity item) {
    final updatedItem = item.copyWith(isCompleted: true);

    // Optimistic UI update: move card immediately for snappy UX
    setState(() {
      _upcomingItems.remove(item);
      _historyItems.insert(0, updatedItem);

      // Auto-checklist corresponding basic immunizations
      final titleLower = item.title.toLowerCase();
      _immunizations = _immunizations.map((imm) {
        final nameLower = imm.name.toLowerCase();
        bool match = false;
        
        if (nameLower == 'dpt 1' && (titleLower.contains('dpt 1') || titleLower.contains('dpt-hb-hib 1') || titleLower.contains('dpt - 1'))) {
          match = true;
        } else if (nameLower == 'dpt 2' && (titleLower.contains('dpt 2') || titleLower.contains('dpt-hb-hib 2') || titleLower.contains('dpt - 2'))) {
          match = true;
        } else if (nameLower == 'dpt 3' && (titleLower.contains('dpt 3') || titleLower.contains('dpt-hb-hib 3') || titleLower.contains('dpt - 3'))) {
          match = true;
        } else if (nameLower == 'polio 1' && titleLower.contains('polio 1')) {
          match = true;
        } else if (nameLower == 'polio 2' && titleLower.contains('polio 2')) {
          match = true;
        } else if (nameLower == 'polio 3' && titleLower.contains('polio 3')) {
          match = true;
        } else if (nameLower == 'polio 4' && titleLower.contains('polio 4')) {
          match = true;
        } else if (nameLower == 'bcg' && titleLower.contains('bcg')) {
          match = true;
        } else if (nameLower == 'campak' && titleLower.contains('campak')) {
          match = true;
        } else if (nameLower == 'mr' && titleLower.contains('mr')) {
          match = true;
        }

        if (match) {
          return ImmunizationItemEntity(
            name: imm.name,
            isDone: true,
          );
        }
        return imm;
      }).toList();
    });

    // Persist the completion to backend/mock via cubit → repository → remote data source
    context.read<PosyanduCubit>().markCompleted(item.id).then((success) {
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} diselesaikan dan tersimpan. Imunisasi terkait otomatis tercentang!'),
            backgroundColor: const Color(0xFF22C55E),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan ke server. Perubahan hanya berlaku sementara.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PosyanduCubit, PosyanduState>(
      listener: (context, state) {
        _seedLocalData(state);
      },
      builder: (context, state) {
        final showInitialLoader =
            state.status == PosyanduStatus.loading && !_seededFromApi;
        final bottomMenuClearance =
            MediaQuery.paddingOf(context).bottom + 128;

        return MainLayout(
          initialIndex: 4,
          child: ColoredBox(
            color: const Color(0xFFF1F5F9),
            child: showInitialLoader
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.only(bottom: bottomMenuClearance),
                    children: [
                      PosyanduHeader(
                        upcomingCount: _upcomingItems.length,
                        completedCount: _historyItems.length,
                        immunizationDoneCount: _immunizations
                            .where((item) => item.isDone)
                            .length,
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImmunizationStatusCard(items: _immunizations),
                            const SizedBox(height: 24),
                            const _PosyanduCentersSection(),
                            if (state.status == PosyanduStatus.failure) ...[
                              const SizedBox(height: 12),
                              _ErrorBanner(
                                message: state.message,
                                onRetry: () => context.read<PosyanduCubit>().load(),
                              ),
                            ],
                            const SizedBox(height: 24),
                            AkanDatangSection(
                              items: _upcomingItems,
                              onAddEvent: _addUpcomingEvent,
                              onMarkCompleted: _markAsCompleted,
                            ),
                            const SizedBox(height: 24),
                            RiwayatSelesaiSection(items: _historyItems),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}


class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDA4AF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE11D48)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF9F1239),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}

class _PosyanduCentersSection extends StatefulWidget {
  const _PosyanduCentersSection();

  @override
  State<_PosyanduCentersSection> createState() => _PosyanduCentersSectionState();
}

class _PosyanduCentersSectionState extends State<_PosyanduCentersSection> {
  final Map<int, bool> _notifStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      for (final center in posyanduCenterDetails) {
        _notifStatus[center.id] = prefs.getBool('posyandu_notif_${center.id}') ?? false;
      }
      _isLoading = false;
    });
  }

  Future<void> _toggleNotification(PosyanduCenterDetail center) async {
    final prefs = await SharedPreferences.getInstance();
    final currentValue = _notifStatus[center.id] ?? false;
    final newValue = !currentValue;
    await prefs.setBool('posyandu_notif_${center.id}', newValue);
    setState(() {
      _notifStatus[center.id] = newValue;
    });

    // Sinkronisasi dengan database notifikasi API
    try {
      final dio = GetIt.I<Dio>();
      final intId = center.id * 1000;
      if (newValue) {
        await dio.post('/api/profile/notifications', data: {
          'id': intId,
          'title': center.name,
          'message': 'Pengingat kunjungan rutin aktif untuk ${center.name} (Bidan: ${center.leaderName}).',
          'type': 'posyandu',
        });
      } else {
        await dio.delete('/api/profile/notifications', queryParameters: {
          'id': intId,
        });
      }
    } catch (e) {
      debugPrint('Gagal menyelaraskan notifikasi: $e');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                newValue ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  newValue
                      ? 'Notifikasi aktif untuk ${center.name}'
                      : 'Notifikasi dinonaktifkan untuk ${center.name}.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: newValue ? const Color(0xFF6366F1) : const Color(0xFF64748B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Posyandu Center',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF25334D),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: posyanduCenterDetails.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final center = posyanduCenterDetails[index];
              final isNotifEnabled = _notifStatus[center.id] ?? false;

              return GestureDetector(
                onTap: () {
                  PosyanduDetailBottomSheet.show(
                    context,
                    posyanduName: center.name,
                    onNotificationToggled: _loadNotificationPreferences,
                  );
                },
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Leading icon/avatar
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              center.address,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            // Badge Bidan
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                center.leaderName,
                                style: const TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Bell Icon
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _toggleNotification(center),
                          child: Ink(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isNotifEnabled ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isNotifEnabled ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                              size: 16,
                              color: isNotifEnabled ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
