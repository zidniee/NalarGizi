import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/dashboard_entity.dart';

class EdukasiGiziSection extends StatelessWidget {
  final List<EducationalContentEntity> contents;

  const EdukasiGiziSection({
    super.key,
    required this.contents,
  });

  /// Buka URL di browser atau aplikasi YouTube.
  Future<void> _openUrl(BuildContext context, String urlStr) async {
    final uri = Uri.tryParse(urlStr);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka: $urlStr'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Tampilkan semua video di bottom sheet.
  void _showAllVideos(BuildContext context) {
    final colorSets = [
      [const Color(0xFFFB7185), const Color(0xFFE11D48), Colors.pink[50]!, Colors.pink[600]!, "Nutrisi"],
      [const Color(0xFF60A5FA), const Color(0xFF3B82F6), Colors.blue[50]!, Colors.blue[600]!, "Edukasi"],
      [const Color(0xFF34D399), const Color(0xFF10B981), Colors.green[50]!, Colors.green[600]!, "Tumbuh"],
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Semua Video Edukasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: contents.isEmpty
                    ? const Center(child: Text('Belum ada konten edukasi.'))
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: contents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, idx) {
                          final item = contents[idx];
                          final colors = colorSets[idx % colorSets.length];
                          return InkWell(
                            onTap: () => _openUrl(ctx, item.mediaUrl),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 80,
                                      height: 56,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          item.thumbnailUrl.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: item.thumbnailUrl,
                                                  fit: BoxFit.cover,
                                                  placeholder: (_, __) => Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [colors[0] as Color, colors[1] as Color],
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (_, __, ___) => Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(colors: [colors[0] as Color, colors[1] as Color]),
                                                    ),
                                                    child: const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24)),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [colors[0] as Color, colors[1] as Color]),
                                                  ),
                                                  child: const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24)),
                                                ),
                                          // Play icon overlay
                                          Center(
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '⏱ ${item.duration}  •  ${colors[4] as String}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors[1] as Color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorSets = [
      [const Color(0xFFFB7185), const Color(0xFFE11D48), Colors.pink[50]!, Colors.pink[600]!, "Nutrisi"],
      [const Color(0xFF60A5FA), const Color(0xFF3B82F6), Colors.blue[50]!, Colors.blue[600]!, "Edukasi"],
      [const Color(0xFF34D399), const Color(0xFF10B981), Colors.green[50]!, Colors.green[600]!, "Tumbuh"],
    ];

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
              onTap: () => _showAllVideos(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[600],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 10, color: Colors.pink[600]),
                  ],
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
            children: contents.isEmpty
                ? [
                    _buildVideoCard(
                      context,
                      "Resep MPASI Ayam Anti Stunting",
                      "03:15",
                      "Nutrisi",
                      const Color(0xFFFB7185),
                      const Color(0xFFE11D48),
                      Colors.pink[50]!,
                      Colors.pink[600]!,
                      thumbnailUrl: 'https://img.youtube.com/vi/FqBrOgPJpUM/hqdefault.jpg',
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
                      thumbnailUrl: 'https://img.youtube.com/vi/hGz9FNxXZJI/hqdefault.jpg',
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
                      thumbnailUrl: 'https://img.youtube.com/vi/V9KNRiG8MPU/hqdefault.jpg',
                    ),
                  ]
                : contents.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final colors = colorSets[idx % colorSets.length];
                    return Padding(
                      padding: EdgeInsets.only(right: idx == contents.length - 1 ? 0 : 12),
                      child: _buildVideoCard(
                        context,
                        item.title,
                        item.duration,
                        colors[4] as String,
                        colors[0] as Color,
                        colors[1] as Color,
                        colors[2] as Color,
                        colors[3] as Color,
                        mediaUrl: item.mediaUrl,
                        thumbnailUrl: item.thumbnailUrl,
                      ),
                    );
                  }).toList(),
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
    Color tagText, {
    String? mediaUrl,
    String? thumbnailUrl,
  }) {
    return GestureDetector(
      onTap: () {
        if (mediaUrl != null && mediaUrl.isNotEmpty) {
          _openUrl(context, mediaUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Memutar video: $title...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background: thumbnail gambar ATAU fallback gradient
                    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [gradStart, gradEnd]),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [gradStart, gradEnd]),
                          ),
                          child: const Center(
                            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [gradStart, gradEnd]),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
                        ),
                      ),

                    // Overlay gelap agar teks mudah dibaca
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                          ],
                        ),
                      ),
                    ),

                    // Icon play di tengah
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                      ),
                    ),

                    // Tag label (kiri atas)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagBg.withValues(alpha: 0.92),
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

                    // Duration badge (kanan bawah)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          duration,
                          style: const TextStyle(fontSize: 9, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
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
