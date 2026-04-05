import 'package:flutter/material.dart';

class ChecklistResultScreen extends StatelessWidget {
  final int checkedCount;
  final int totalCount;
  final String language;

  const ChecklistResultScreen({
    super.key,
    required this.checkedCount,
    required this.totalCount,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
    final percentage = checkedCount / totalCount;

    String message;
    Color color;
    IconData icon;

    if (percentage <= 0.3) {
      message = isArabic
          ? 'لا توجد علامات مقلقة في الوقت الحالي'
          : 'No concerning signs at this time';
      color = const Color(0xFF96C7B3);
      icon = Icons.check_circle;
    } else if (percentage <= 0.6) {
      message = isArabic
          ? 'بعض العلامات موجودة، يُنصح باستشارة متخصص'
          : 'Some signs present, consider consulting a specialist';
      color = const Color(0xFFF9B95C);
      icon = Icons.warning;
    } else {
      message = isArabic
          ? 'علامات متعددة موجودة، يُرجى استشارة متخصص في أقرب وقت'
          : 'Multiple signs present, please consult a specialist soon';
      color = const Color(0xFFD7897F);
      icon = Icons.error;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'النتائج' : 'Results'),
        backgroundColor: const Color(0xFF96C7B3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 24),
            Text(
              '$checkedCount / $totalCount',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'علامات تم تحديدها' : 'Signs checked',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
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
                isArabic ? 'العودة للرئيسية' : 'Back to Home',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}