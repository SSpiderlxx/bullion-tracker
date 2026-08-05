import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // Uncomment when firebase is setup
import 'app.dart';
import 'data/database/app_database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Assuming firebase_core is added to pubspec.yaml)
  // await Firebase.initializeApp();

  // Initialize Local Database
  await AppDatabase().init();

  runApp(
    const ProviderScope(
      child: BullionTrackerApp(),
    ),
  );
}
