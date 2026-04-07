import 'package:flutter/material.dart';

class RingkasanNutrisiHeader extends StatelessWidget {
  const RingkasanNutrisiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFF5200)], // Gradient Oren persis Figma
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const Text('Jurnal Nutrisi Harian', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('3 Maret 2026', style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 24),
          // Kotak efek transparan (Glassmorphism)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoKolom('Total Kalori', '🔥 330', 'kkal', isBold: true),
                    Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                    _buildInfoKolom('Target', '800', ''),
                    Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                    _buildInfoKolom('Sisa', '470', ''),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 330 / 800,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    color: Colors.yellow, // Progress bar kuning
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoKolom(String title, String value, String unit, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(color: Colors.white, fontSize: isBold ? 24 : 22, fontWeight: FontWeight.bold)),
            if (unit.isNotEmpty) const SizedBox(width: 4),
            if (unit.isNotEmpty) Text(unit, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}