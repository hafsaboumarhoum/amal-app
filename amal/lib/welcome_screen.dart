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
              'Bloom',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Color(0xFF6398A9),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'اختر اللغة المناسبة لك',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            
            // Row with language buttons side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _languageButton(
                    context, '🇲🇦  العربية', const Color(0xFF1A7F4B), 'ar'),
                const SizedBox(width: 20),
                _languageButton(
                    context, '🇬🇧  English', const Color(0xFF2E75B6), 'en'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Language button function
  Widget _languageButton(
      BuildContext context, String label, Color color, String language) {
    return SizedBox(
      width: 140,
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
            MaterialPageRoute(
              builder: (_) => HomeScreen(language: language),
            ),
          );
        },
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}