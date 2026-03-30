import 'package:flutter/material.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AMAL | أمل',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6398A9),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'اختر اللغة المناسبة لك',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            _languageButton(
              context,
              '🇲🇦  العربية',
              const Color(0xFF6398A9),
              'ar',
            ),
            const SizedBox(height: 16),
            _languageButton(
              context,
              '🇬🇧  English',
              const Color(0xFFD7897F),
              'en',
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageButton(
    BuildContext context,
    String label,
    Color color,
    String lang,
  ) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(language: lang)),
          );
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
