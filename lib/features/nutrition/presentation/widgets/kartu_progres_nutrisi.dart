import 'package:flutter/material.dart';

class KartuProgresNutrisi extends StatelessWidget {
  const KartuProgresNutrisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Nutrisi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildProgressItem('Protein (g)', '12/20', 12/20, const Color(0xFFF43F5E)), // Pink
          _buildProgressItem('Zat Besi (mg)', '6/11', 6/11, Colors.orange), // Oren/Kuning
          _buildProgressItem('Kalsium (mg)', '180/300', 180/300, Colors.blue), // Biru
          _buildProgressItem('Vitamin A (mcg)', '200/400', 200/400, const Color(0xFFFF8A00)), // Oren tua
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}