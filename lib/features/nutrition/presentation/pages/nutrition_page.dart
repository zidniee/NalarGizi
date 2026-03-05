import 'package:flutter/material.dart';

import '../widgets/nutrition_summary_card.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: NutritionSummaryCard(),
      ),
    );
  }
}
