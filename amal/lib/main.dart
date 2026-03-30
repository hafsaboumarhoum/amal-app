import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome_screen.dart';
import 'screens/specialist_directory_screen.dart';
import 'screens/daily_guide_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AmalApp());
}

class AmalApp extends StatelessWidget {
  const AmalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMAL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6398A9),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}