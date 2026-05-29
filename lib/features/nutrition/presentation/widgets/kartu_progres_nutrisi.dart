import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_entity.dart';

class KartuProgresNutrisi extends StatelessWidget {
  final NutritionDailyEntity? dailyData;

  const KartuProgresNutrisi({super.key, this.dailyData});

  @override
  Widget build(BuildContext context) {
    final carbs = dailyData?.consumedCarbs ?? 0;
    final carbsTarget = dailyData?.targetCarbs ?? 150;
    final carbsFraction = carbsTarget > 0 ? (carbs / carbsTarget).clamp(0.0, 1.0) : 0.0;

    final protein = dailyData?.consumedProtein ?? 0;
    final proteinTarget = dailyData?.targetProtein ?? 40;
    final proteinFraction = proteinTarget > 0 ? (protein / proteinTarget).clamp(0.0, 1.0) : 0.0;

    final fat = dailyData?.consumedFat ?? 0;
    final fatTarget = dailyData?.targetFat ?? 35;
    final fatFraction = fatTarget > 0 ? (fat / fatTarget).clamp(0.0, 1.0) : 0.0;

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
          const Text('Ringkasan Nutrisi Makro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildProgressItem('Karbohidrat (g)', '$carbs/$carbsTarget', carbsFraction, Colors.orange),
          _buildProgressItem('Protein (g)', '$protein/$proteinTarget', proteinFraction, const Color(0xFFF43F5E)),
          _buildProgressItem('Lemak (g)', '$fat/$fatTarget', fatFraction, Colors.blue),
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