import 'package:flutter/material.dart';

class InfoPosyanduBanner extends StatelessWidget {
  const InfoPosyanduBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // ClipRRect berfungsi memotong dekorasi bundaran yang keluar dari batas kotak
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // 1. Latar Belakang Gradient & Teks Utama
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF97316),
                  Color(0xFFEF4444),
                ], // Orange ke Merah
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📣 INFO POSYANDU",
                        style: TextStyle(
                          color: Color(0xFFFFEDD5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Bawa Buku KIA setiap kunjungan Posyandu!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.trending_up, color: Colors.white, size: 28),
              ],
            ),
          ),

          // 2. Bundaran Putih Pudar (Dekorasi)
          Positioned(
            right: -16, // Digeser sedikit keluar batas kanan
            bottom: -16, // Digeser sedikit keluar batas bawah
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(
                  0.1,
                ), // Putih dengan transparansi 10%
              ),
            ),
          ),
        ],
      ),
    );
  }
}
