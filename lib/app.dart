import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

class BullionTrackerApp extends StatelessWidget {
  const BullionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bullion Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports switching based on system preferences
      routerConfig: appRouter,
    );
  }
}
