import 'package:flutter/material.dart';

import '../widgets/dashboard_summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: DashboardSummaryCard(),
      ),
    );
  }
}
