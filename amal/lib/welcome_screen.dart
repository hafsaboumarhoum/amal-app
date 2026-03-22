import 'package:flutter/material.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AMAL | أمل',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a7f4b),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
'اختر اللغة المناسبة لك',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            _languageButton('🇲🇦  العربية', const Color(0xFF1a7f4b)),
            const SizedBox(height: 16),
            _languageButton('🇬🇧  English', const Color(0xFF2E75B6)),
          ],
        ),
      ),
    );
  }

 Widget _languageButton(String label, Color color) {
  return SizedBox(
    width: 260,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- fixed this line
        ),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}
}