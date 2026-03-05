import 'package:flutter/material.dart';

import '../widgets/posyandu_summary_card.dart';

class PosyanduPage extends StatelessWidget {
  const PosyanduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posyandu')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: PosyanduSummaryCard(),
      ),
    );
  }
}
