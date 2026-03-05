import 'package:flutter/material.dart';

import '../widgets/profile_summary_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: ProfileSummaryCard(),
      ),
    );
  }
}
