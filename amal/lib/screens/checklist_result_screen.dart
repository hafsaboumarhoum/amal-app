import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:amal/screens/specialist_directory_screen.dart';
import 'dart:convert';

class ChecklistResultScreen extends StatefulWidget {
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
  State<ChecklistResultScreen> createState() => _ChecklistResultScreenState();
}

class _ChecklistResultScreenState extends State<ChecklistResultScreen> {

  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = prefs.getStringList('checklist_sessions') ?? [];
    final session = json.encode({
      'date': DateTime.now().toIso8601String(),
      'score': widget.checkedCount,
      'maxScore': widget.totalCount,
      'percentage': (widget.checkedCount / widget.totalCount * 100).round(),
    });
    sessions.add(session);
    await prefs.setStringList('checklist_sessions', sessions);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    final percentage = widget.checkedCount / widget.totalCount;

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
              '${widget.checkedCount} / ${widget.totalCount}',
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
            ElevatedButton.icon(
              onPressed: () {
                final pct = (widget.checkedCount / widget.totalCount * 100).round();
                final text = widget.language == 'ar'
                    ? 'نتائج فحص بلوم: $pct%\n\nهذه القائمة ليست تشخيصاً.'
                    : 'Bloom Checklist Results: $pct%\n\nThis checklist is not a diagnosis.';
                Share.share(text);
              },
              icon: const Icon(Icons.share),
              label: Text(isArabic ? 'مشاركة النتائج' : 'Share Results'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF96C7B3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SpecialistDirectoryScreen(language: widget.language),
                ));
              },
              icon: const Icon(Icons.local_hospital),
              label: Text(isArabic ? 'ابحث عن مختص' : 'Find a Specialist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD7897F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
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