import 'package:flutter/material.dart';

class EdukasiGiziSection extends StatelessWidget {
  const EdukasiGiziSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Edukasi
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Edukasi Gizi Bunda",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Membuka halaman Semua Video Edukasi...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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

        // Daftar Video Scroll Horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildVideoCard(
                context,
                "Resep MPASI Ayam Anti Stunting",
                "03:15",
                "Nutrisi",
                const Color(0xFFFB7185),
                const Color(0xFFE11D48),
                Colors.pink[50]!,
                Colors.pink[600]!,
              ),
              const SizedBox(width: 12),
              _buildVideoCard(
                context,
                "Pentingnya 1000 Hari Pertama",
                "05:42",
                "Edukasi",
                const Color(0xFF60A5FA),
                const Color(0xFF3B82F6),
                Colors.blue[50]!,
                Colors.blue[600]!,
              ),
              const SizedBox(width: 12),
              _buildVideoCard(
                context,
                "Stimulasi Motorik Anak Usia 12-18 Bulan",
                "04:20",
                "Tumbuh",
                const Color(0xFF34D399),
                const Color(0xFF10B981),
                Colors.green[50]!,
                Colors.green[600]!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    String title,
    String duration,
    String tag,
    Color gradStart,
    Color gradEnd,
    Color tagBg,
    Color tagText,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Memutar video: $title...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Video
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(colors: [gradStart, gradEnd]),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.videocam, color: Colors.white, size: 24),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: tagText,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Judul Video
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
