import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class PosyanduCenterDetail {
  final int id;
  final String name;
  final String address;
  final String leaderName;
  final String phone;
  final String schedule;
  final List<String> services;

  const PosyanduCenterDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.leaderName,
    required this.phone,
    required this.schedule,
    required this.services,
  });
}

const List<PosyanduCenterDetail> posyanduCenterDetails = [
  PosyanduCenterDetail(
    id: 1,
    name: 'Posyandu Mawar 1',
    address: 'Jl. Mawar Merah No. 45, RT 02/RW 03, Jakarta Selatan',
    leaderName: 'Bidan Siti Aminah',
    phone: '0812-3456-7890',
    schedule: 'Setiap hari Rabu pertama tiap bulan, 08:00 - 12:00 WIB',
    services: [
      'Timbang Berat Badan & Tinggi',
      'Pemberian Vitamin A (Februari & Agustus)',
      'Imunisasi Dasar Lengkap (BCG, DPT, Polio, Campak/MR)',
      'Pemberian Makanan Tambahan (PMT) Gizi',
      'Konsultasi Gizi Anak & Ibu Menyusui',
    ],
  ),
  PosyanduCenterDetail(
    id: 2,
    name: 'Posyandu Melati 2',
    address: 'Jl. Melati Raya No. 12, RT 05/RW 01, Jakarta Selatan',
    leaderName: 'Bidan Lestari',
    phone: '0813-8822-1100',
    schedule: 'Setiap hari Kamis kedua tiap bulan, 08:00 - 12:00 WIB',
    services: [
      'Timbang Berat Badan & Tinggi',
      'Pemberian Vitamin A',
      'Imunisasi Dasar & Booster',
      'Penyuluhan Gizi & Pencegahan Stunting',
      'Pemberian Makanan Tambahan (PMT)',
    ],
  ),
  PosyanduCenterDetail(
    id: 3,
    name: 'Posyandu Anggrek 3',
    address: 'Jl. Anggrek Indah No. 8, RT 01/RW 04, Jakarta Selatan',
    leaderName: 'Bidan Dian',
    phone: '0857-1122-3344',
    schedule: 'Setiap hari Sabtu pertama tiap bulan, 09:00 - 13:00 WIB',
    services: [
      'Timbang Berat Badan & Tinggi',
      'Deteksi Dini Tumbuh Kembang (DDTK)',
      'Pemberian Vitamin A & Obat Cacing',
      'Pemberian Makanan Tambahan (PMT)',
      'Imunisasi Dasar Lengkap',
    ],
  ),
];

class PosyanduDetailBottomSheet extends StatefulWidget {
  final String posyanduName;
  final VoidCallback? onNotificationToggled;

  const PosyanduDetailBottomSheet({
    super.key,
    required this.posyanduName,
    this.onNotificationToggled,
  });

  static Future<void> show(
    BuildContext context, {
    required String posyanduName,
    VoidCallback? onNotificationToggled,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PosyanduDetailBottomSheet(
        posyanduName: posyanduName,
        onNotificationToggled: onNotificationToggled,
      ),
    );
  }

  @override
  State<PosyanduDetailBottomSheet> createState() => _PosyanduDetailBottomSheetState();
}

class _PosyanduDetailBottomSheetState extends State<PosyanduDetailBottomSheet> {
  late PosyanduCenterDetail _detail;
  bool _notificationsEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _findDetail();
    _loadNotificationPreference();
  }

  void _findDetail() {
    final nameLower = widget.posyanduName.toLowerCase();
    _detail = posyanduCenterDetails.firstWhere(
      (c) => nameLower.contains(c.name.toLowerCase()) || c.name.toLowerCase().contains(nameLower),
      orElse: () => PosyanduCenterDetail(
        id: 99,
        name: widget.posyanduName,
        address: 'Lokasi Posyandu Terdekat pilihan Anda',
        leaderName: 'Bidan Rahma',
        phone: '0812-3456-7890',
        schedule: 'Setiap bulan sesuai jadwal dari RT/RW setempat',
        services: [
          'Timbang Berat Badan & Tinggi',
          'Pemberian Vitamin A',
          'Imunisasi Dasar Lengkap',
          'Pemberian Makanan Tambahan (PMT)',
        ],
      ),
    );
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('posyandu_notif_${_detail.id}') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_notificationsEnabled;
    await prefs.setBool('posyandu_notif_${_detail.id}', newValue);
    setState(() {
      _notificationsEnabled = newValue;
    });

    // Sinkronisasi dengan database notifikasi API
    try {
      final dio = GetIt.I<Dio>();
      final intId = _detail.id * 1000;
      if (newValue) {
        await dio.post('/api/profile/notifications', data: {
          'id': intId,
          'title': _detail.name,
          'message': 'Pengingat kunjungan rutin aktif untuk ${_detail.name} (Bidan: ${_detail.leaderName}).',
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

    if (widget.onNotificationToggled != null) {
      widget.onNotificationToggled!();
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
                      ? 'Pengingat lonceng diaktifkan untuk ${_detail.name}!'
                      : 'Pengingat untuk ${_detail.name} dinonaktifkan.',
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
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: Color(0xFF6366F1),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _detail.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                _detail.leaderName,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Persist Bell Switch / Notification Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedCrossFade(
                          firstChild: const Icon(
                            Icons.notifications_active_rounded,
                            color: Color(0xFF6366F1),
                            size: 24,
                          ),
                          secondChild: const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xFF94A3B8),
                            size: 24,
                          ),
                          crossFadeState: _notificationsEnabled
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pengingat Lonceng',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _notificationsEnabled
                                  ? 'Notifikasi aktif untuk posyandu ini.'
                                  : 'Aktifkan agar tidak ketinggalan jadwal.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Switch.adaptive(
                              value: _notificationsEnabled,
                              activeThumbColor: const Color(0xFF6366F1),
                              onChanged: (_) => _toggleNotification(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Detail Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Umum',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Address
                    _buildInfoRow(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFFEF4444),
                      title: 'Alamat',
                      content: _detail.address,
                    ),
                    const SizedBox(height: 12),

                    // Phone
                    _buildInfoRow(
                      icon: Icons.phone_rounded,
                      iconColor: const Color(0xFF10B981),
                      title: 'Telepon Bidan',
                      content: _detail.phone,
                    ),
                    const SizedBox(height: 12),

                    // Schedule
                    _buildInfoRow(
                      icon: Icons.access_time_filled_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Jadwal Rutin',
                      content: _detail.schedule,
                    ),
                    const SizedBox(height: 24),

                    // Services List
                    const Text(
                      'Layanan & Fasilitas',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._detail.services.map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF10B981),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                service,
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
