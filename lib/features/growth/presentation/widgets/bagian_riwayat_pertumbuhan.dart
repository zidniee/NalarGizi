import 'package:flutter/material.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';

class BagianRiwayatPertumbuhan extends StatelessWidget {
  final List<GrowthRecordEntity> records;
  final bool isBeratBadan;
  final VoidCallback onAddPressed;

  const BagianRiwayatPertumbuhan({
    super.key,
    required this.records,
    required this.isBeratBadan,
    required this.onAddPressed,
  });

  String _formatMonth(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length >= 2) {
        final monthInt = int.parse(parts[1]);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
          'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        if (monthInt >= 1 && monthInt <= 12) {
          return months[monthInt - 1];
        }
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Pengukuran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (records.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Belum ada riwayat pengukuran.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = records[index];
              final isLatest = index == 0;

              // Calculate difference from the previous measurement (next in index, since sorted newest -> oldest)
              double diff = 0;
              if (index + 1 < records.length) {
                final prev = records[index + 1];
                diff = isBeratBadan 
                    ? (record.weightKg - prev.weightKg) 
                    : (record.heightCm - prev.heightCm);
              }

              String increaseLabel = '';
              if (isBeratBadan) {
                final grams = (diff * 1000).round();
                increaseLabel = grams >= 0 ? '+$grams gram' : '$grams gram';
              } else {
                final formattedDiff = diff.toStringAsFixed(1);
                increaseLabel = diff >= 0 ? '+$formattedDiff cm' : '$formattedDiff cm';
              }

              final totalLabel = isBeratBadan 
                  ? '${record.weightKg.toStringAsFixed(1)} kg' 
                  : '${record.heightCm.toStringAsFixed(1)} cm';

              final monthLabel = _formatMonth(record.recordedAt);
              final title = 'Bulan ${record.ageMonths} ${monthLabel.isNotEmpty ? '($monthLabel)' : ''}';

              return _buildHistoryItem(
                title, 
                increaseLabel, 
                totalLabel, 
                record.zScoreStatus,
                isLatest,
              );
            },
          ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('Tambah Pengukuran Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    String title, 
    String increase, 
    String total, 
    String status,
    bool isActive,
  ) {
    final isNormal = status.toLowerCase() == 'normal';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF43F5E).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? const Color(0xFFF43F5E).withOpacity(0.3) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF43F5E).withOpacity(0.1) : Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBeratBadan ? Icons.scale_outlined : Icons.height, 
              color: isActive ? const Color(0xFFF43F5E) : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      increase.startsWith('-') ? Icons.trending_down : Icons.trending_up, 
                      color: increase.startsWith('-') ? Colors.red : const Color(0xFF10B981), 
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      increase, 
                      style: TextStyle(
                        color: increase.startsWith('-') ? Colors.red : const Color(0xFF10B981), 
                        fontSize: 12, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: TextStyle(color: isActive ? const Color(0xFFF43F5E) : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isNormal ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFFF59E0B).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status, 
                  style: TextStyle(
                    color: isNormal ? const Color(0xFF10B981) : const Color(0xFFF59E0B), 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}