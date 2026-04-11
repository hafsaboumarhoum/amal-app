import 'package:flutter/material.dart';
import 'checklist_screen.dart';

class ChecklistIntroScreen extends StatelessWidget {
  final String language;

  const ChecklistIntroScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(
          isArabic ? 'قائمة العلامات المبكرة' : 'Early Signs Checklist',
        ),
        backgroundColor: const Color(0xFF96C7B3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.checklist,
              size: 80,
              color: Color(0xFF96C7B3),
            ),
            const SizedBox(height: 24),
            Text(
              isArabic
                  ? 'هل تلاحظ علامات مبكرة؟'
                  : 'Are you noticing early signs?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? 'هذه القائمة تساعدك على ملاحظة علامات التوحد المبكرة حسب عمر طفلك.'
                  : 'This checklist helps you notice early signs of autism based on your child\'s age.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChecklistScreen(language: language),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF96C7B3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isArabic ? 'ابدأ' : 'Start',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}