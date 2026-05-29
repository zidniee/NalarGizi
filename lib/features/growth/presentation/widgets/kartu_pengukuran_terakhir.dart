import 'package:flutter/material.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';

class KartuPengukuranTerakhir extends StatelessWidget {
  final List<GrowthRecordEntity> records;
  final bool isBeratBadan;

  const KartuPengukuranTerakhir({
    super.key, 
    required this.records,
    required this.isBeratBadan,
  });

  @override
  Widget build(BuildContext context) {
    final latest = records.isNotEmpty ? records.first : null;
    final previous = records.length > 1 ? records[1] : null;

    // 1. Nilai Terakhir
    String latestValue = '-';
    if (latest != null) {
      latestValue = isBeratBadan 
          ? latest.weightKg.toStringAsFixed(1) 
          : latest.heightCm.toStringAsFixed(1);
    }

    String ageLabel = latest != null 
        ? 'Bulan ke-${latest.ageMonths}' 
        : 'Belum ada data';

    // 2. Kenaikan Bulan Ini
    double diff = 0;
    if (latest != null && previous != null) {
      diff = isBeratBadan 
          ? (latest.weightKg - previous.weightKg) 
          : (latest.heightCm - previous.heightCm);
    }

    final isPositive = diff >= 0;
    final diffLabel = isPositive 
        ? '+${diff.abs().toStringAsFixed(1)}' 
        : '-${diff.abs().toStringAsFixed(1)}';

    final trendIcon = diff == 0 
        ? Icons.trending_flat 
        : (isPositive ? Icons.trending_up : Icons.trending_down);
        
    final trendColor = diff == 0 
        ? Colors.grey 
        : (isPositive ? const Color(0xFF10B981) : Colors.red);

    final statusLabel = latest?.zScoreStatus ?? 'Tidak ada data';
    final isNormal = statusLabel.toLowerCase() == 'normal';

    return Row(
      children: [
        // KARTU 1: PENGUKURAN TERAKHIR
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pengukuran\nTerakhir', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      latestValue, 
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E)),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBeratBadan ? 'kg' : 'cm', 
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(ageLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // KARTU 2: KENAIKAN BULAN INI
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kenaikan Bulan Ini', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Icon(trendIcon, color: trendColor, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      diffLabel, 
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: trendColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBeratBadan ? 'kg' : 'cm', 
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: trendColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: latest == null 
                        ? Colors.grey.shade100 
                        : (isNormal ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFFF59E0B).withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel, 
                    style: TextStyle(
                      color: latest == null 
                          ? Colors.grey 
                          : (isNormal ? const Color(0xFF10B981) : const Color(0xFFF59E0B)), 
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
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