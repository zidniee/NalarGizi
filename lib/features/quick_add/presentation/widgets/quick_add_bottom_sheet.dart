import 'package:flutter/material.dart';

class QuickAddBottomSheet extends StatelessWidget {
  const QuickAddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar tingginya menyesuaikan isi
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis kecil di tengah atas (Handle)
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Judul dan Tombol Silang (X)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah Data Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pilih jenis data yang ingin dicatat',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context), // Aksi menutup pop-up
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol 1: Catat Berat & Tinggi
          _buildMenuCard(
            context, // Perlu mengirim context agar notifikasi jalan
            title: 'Catat Berat & Tinggi',
            subtitle: 'Update data pertumbuhan bulan ini',
            icon: Icons.scale_outlined,
            iconColor: Colors.red,
            bgColor: Colors.red[50]!,
          ),
          const SizedBox(height: 12),

          // Tombol 2: Jurnal Nutrisi Harian
          _buildMenuCard(
            context,
            title: 'Jurnal Nutrisi Harian',
            subtitle: 'Catat menu makanan (MPASI) anak',
            icon: Icons.restaurant_menu,
            iconColor: Colors.orange,
            bgColor: Colors.orange[50]!,
          ),
          const SizedBox(height: 12),

          // Tombol 3: Jadwal Posyandu Baru
          _buildMenuCard(
            context,
            title: 'Jadwal Posyandu Baru',
            subtitle: 'Buat pengingat imunisasi/timbang',
            icon: Icons.calendar_today,
            iconColor: Colors.indigo,
            bgColor: Colors.indigo[50]!,
          ),

          const SizedBox(height: 16), // Jarak aman ke bawah
        ],
      ),
    );
  }

  // Widget bantuan dengan tambahan parameter context
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () {
        // 1. Tutup pop-up Bottom Sheet
        Navigator.pop(context);

        // 2. Munculkan notifikasi (SnackBar) pura-pura di bawah layar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Membuka form $title...'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: iconColor,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: iconColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: iconColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
