import 'package:flutter/material.dart';
import 'package:nalargizi/app/router/app_router.dart';
import 'package:nalargizi/features/auth/presentation/pages/login_page.dart';
import 'package:nalargizi/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nalargizi/features/growth/presentation/pages/growth_page.dart';
import 'package:nalargizi/features/home/home.dart';
import 'package:nalargizi/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:nalargizi/features/posyandu/presentation/pages/posyandu_page.dart';
import 'package:nalargizi/features/profile/presentation/pages/profile_page.dart';
import 'package:nalargizi/features/quick_add/presentation/pages/quick_add_page.dart';

import 'theme/app_theme.dart';

class NalarGiziApp extends StatelessWidget {
  const NalarGiziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NalarGizi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomePage(),
      routes: {
        AppRouter.home: (_) => const HomePage(),
        AppRouter.login: (_) => const LoginPage(),
        AppRouter.dashboard: (_) => const DashboardPage(),
        AppRouter.growth: (_) => const GrowthPage(),
        AppRouter.nutrition: (_) => const NutritionPage(),
        AppRouter.posyandu: (_) => const PosyanduPage(),
        AppRouter.quickAdd: (_) => const QuickAddPage(),
        AppRouter.profile: (_) => const ProfilePage(),
      },
    );
  }
}
