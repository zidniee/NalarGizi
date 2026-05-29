import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:nalargizi/app/router/app_router.dart';
import 'package:nalargizi/shared/widgets/posyandu_detail_bottom_sheet.dart';
import '../../domain/entities/dashboard_entity.dart';

class JadwalTerdekatCard extends StatefulWidget {
  final NearestScheduleEntity? schedule;

  const JadwalTerdekatCard({
    super.key,
    this.schedule,
  });

  @override
  State<JadwalTerdekatCard> createState() => _JadwalTerdekatCardState();
}

class _JadwalTerdekatCardState extends State<JadwalTerdekatCard> {
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  @override
  void didUpdateWidget(covariant JadwalTerdekatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.schedule?.id != widget.schedule?.id) {
      _loadNotificationStatus();
    }
  }

  Future<void> _loadNotificationStatus() async {
    final item = widget.schedule;
    if (item == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('posyandu_schedule_notif_${item.id}') ?? false;
    });
  }

  Future<void> _toggleNotification() async {
    final item = widget.schedule;
    if (item == null) return;

    final prefs = await SharedPreferences.getInstance();
    final newValue = !_isNotificationEnabled;
    await prefs.setBool('posyandu_schedule_notif_${item.id}', newValue);
    setState(() {
      _isNotificationEnabled = newValue;
    });

    // Sinkronisasi dengan database notifikasi API
    try {
      final dio = GetIt.I<Dio>();
      if (newValue) {
        await dio.post('/api/profile/notifications', data: {
          'id': item.id,
          'title': item.title,
          'message': 'Jangan lupa untuk menghadiri ${item.title} di ${item.posyanduCenterName}.',
          'type': 'posyandu',
        });
      } else {
        await dio.delete('/api/profile/notifications', queryParameters: {
          'id': item.id,
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
                      ? 'Pengingat diaktifkan untuk: ${item.title}'
                      : 'Pengingat dinonaktifkan.',
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
    final item = widget.schedule;
    if (item == null) {
      return const SizedBox.shrink();
    }

    String monthAbbr = "NOV";
    String dayStr = "20";
    try {
      final parsedDate = DateTime.parse(item.eventDate);
      const months = [
        "JAN", "FEB", "MAR", "APR", "MEI", "JUN",
        "JUL", "AGU", "SEP", "OKT", "NOV", "DES"
      ];
      monthAbbr = months[parsedDate.month - 1];
      dayStr = parsedDate.day.toString();
    } catch (_) {
      // Fallback
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Teks Jadwal Terdekat & Lihat Semua)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  "Jadwal Terdekat",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouter.posyandu);
              },
              child: Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[500],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            PosyanduDetailBottomSheet.show(
              context,
              posyanduName: item.posyanduCenterName,
              onNotificationToggled: _loadNotificationStatus,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        monthAbbr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dayStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Info Detail Jadwal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.posyanduCenterName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tombol Lonceng Interaktif
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _toggleNotification,
                    child: Ink(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _isNotificationEnabled ? const Color(0xFFEEF2FF) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isNotificationEnabled ? const Color(0xFFC7D2FE) : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        _isNotificationEnabled ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                        size: 18,
                        color: _isNotificationEnabled ? const Color(0xFF6366F1) : Colors.grey[600],
                      ),
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

