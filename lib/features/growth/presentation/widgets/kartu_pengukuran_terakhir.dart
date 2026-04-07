import 'package:flutter/material.dart';

class KartuPengukuranTerakhir extends StatelessWidget {
  final bool isBeratBadan;

  const KartuPengukuranTerakhir({super.key, required this.isBeratBadan});

  @override
  Widget build(BuildContext context) {
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
                    Text(isBeratBadan ? '9.8' : '76.5', 
                         style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E))),
                    const SizedBox(width: 4),
                    Text(isBeratBadan ? 'kg' : 'cm', 
                         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E))),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Bulan ke-14', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                    const Icon(Icons.trending_up, color: Color(0xFF10B981), size: 24),
                    const SizedBox(width: 4),
                    Text(isBeratBadan ? '+0.4' : '+1.5', 
                         style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                    const SizedBox(width: 4),
                    Text(isBeratBadan ? 'kg' : 'cm', 
                         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Normal', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}