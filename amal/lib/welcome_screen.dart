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
<<<<<<< HEAD
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
=======
            
            // ✅ Row with language buttons side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _languageButton(context, '🇲🇦  العربية', const Color(0xFF1a7f4b), 'ar'),
                const SizedBox(width: 20), // spacing between buttons
                _languageButton(context, '🇬🇧  English', const Color(0xFF2E75B6), 'en'),
              ],
>>>>>>> 54a6407 (WIP: added home screen, updated welcome screen, assets, and configs)
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget SizedBox _languageButton(
    BuildContext context,
    String label,
    Color color,
    String lang,
  ) {
    return SizedBox(
      width: 260,
=======
  // ✅ Language button function
  Widget _languageButton(BuildContext context, String label, Color color, String language) {
    return SizedBox(
      width: 140, // smaller width so both fit side by side
>>>>>>> 54a6407 (WIP: added home screen, updated welcome screen, assets, and configs)
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
<<<<<<< HEAD
            MaterialPageRoute(builder: (_) => HomeScreen(language: lang)),
=======
            MaterialPageRoute(
              builder: (_) => HomeScreen(language: language),
            ),
>>>>>>> 54a6407 (WIP: added home screen, updated welcome screen, assets, and configs)
          );
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.white),
<<<<<<< HEAD
=======
          textAlign: TextAlign.center,
>>>>>>> 54a6407 (WIP: added home screen, updated welcome screen, assets, and configs)
        ),
      ),
    );
  }
}
