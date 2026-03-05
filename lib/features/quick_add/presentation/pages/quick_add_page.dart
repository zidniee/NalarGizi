import 'package:flutter/material.dart';

import '../widgets/quick_add_summary_card.dart';

class QuickAddPage extends StatelessWidget {
  const QuickAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Add')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: QuickAddSummaryCard(),
      ),
    );
  }
}
