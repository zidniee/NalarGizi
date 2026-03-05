import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class NalarGiziApp extends StatelessWidget {
  const NalarGiziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NalarGizi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SplashPage(),
    );
  }
}
