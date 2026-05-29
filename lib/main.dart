import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/di/injection.dart';

/// Entry point for NalarGizi application.
///
/// Initialization order:
/// 1. Flutter bindings
/// 2. Hive (offline-first local storage) — claude2.md §4
/// 3. GetIt dependency injection — claude2.md §3
/// 4. SharedPreferences flags lookup
/// 5. runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline-first caching (claude2.md §4)
  await Hive.initFlutter();

  // Register all dependencies (claude2.md §3)
  await configureDependencies();

  // Load preferences for dynamic startup route
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(NalarGiziApp(
    onboardingCompleted: onboardingCompleted,
    isLoggedIn: isLoggedIn,
  ));
}
