import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'specialist_directory_screen.dart';
import 'dart:convert';

class ChecklistResultScreen extends StatefulWidget {
  final int checkedCount;
  final int totalCount; // This will now likely be 20
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
    // Adjusted thresholds: 
    // < 15% (3/20 signs) = Low risk
    // 15-40% (4-8/20 signs) = Medium risk
    // > 40% (9+ signs) = High risk
    final percentage = widget.checkedCount / widget.totalCount;

    String message;
    Color color;
    IconData icon;

    if (percentage < 0.15) {
      message = isArabic
          ? 'تطور طفلك يبدو طبيعياً. استمر في المراقبة الدورية.'
          : 'Your child\'s development appears typical. Continue regular monitoring.';
      color = const Color(0xFFB4D3D9); // Teal
      icon = Icons.check_circle_outline;
    } else if (percentage <= 0.4) {
      message = isArabic
          ? 'تم اكتشاف بعض العلامات المبكرة. نقترح استشارة أخصائي للتحقق.'
          : 'Some early signs detected. We suggest consulting a specialist for a check-up.';
      color = const Color(0xFFBDA6CE); // Muted Purple
      icon = Icons.info_outline;
    } else {
      message = isArabic
          ? 'هناك عدة علامات تستدعي الاهتمام. يُنصح بحجز موعد تقييم في أقرب وقت.'
          : 'Multiple signs present that require attention. It is recommended to book an evaluation soon.';
      color = const Color(0xFF9B8EC7); // Deep Lavender
      icon = Icons.warning_amber_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'نتائج الفحص المبكر' : 'Early Screening Results'),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Added scroll for smaller screens
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: color),
              const SizedBox(height: 24),
              Text(
                '${widget.checkedCount} / ${widget.totalCount}',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic ? 'علامات تم رصدها' : 'Identified Signs',
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 17,
                        color: color.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArabic 
                        ? '* هذه النتائج ليست تشخيصاً طبياً نهائياً.' 
                        : '* These results are not a final medical diagnosis.',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Action Buttons
              _buildActionButton(
                onPressed: () {
                  final pct = (widget.checkedCount / widget.totalCount * 100).round();
                  final text = isArabic
                      ? 'نتائج فحص علامات التوحد المبكرة: $pct%\nتم تحديد ${widget.checkedCount} علامة من أصل ${widget.totalCount}.\n\n(تطبيق بلوم - ملاحظة: هذا ليس تشخيصاً)'
                      : 'Early Autism Screening Results: $pct%\nIdentified ${widget.checkedCount} out of ${widget.totalCount} signs.\n\n(Bloom App - Note: Not a diagnosis)';
                  Share.share(text);
                },
                icon: Icons.share_rounded,
                label: isArabic ? 'مشاركة النتائج مع المختص' : 'Share Results with Specialist',
                backgroundColor: const Color(0xFFB4D3D9),
              ),
              
              const SizedBox(height: 12),
              
              _buildActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => SpecialistDirectoryScreen(language: widget.language),
                  ));
                },
                icon: Icons.map_outlined,
                label: isArabic ? 'تواصل مع مراكز التقييم' : 'Connect with Assessment Centers',
                backgroundColor: const Color(0xFFBDA6CE),
              ),
              
              const SizedBox(height: 12),
              
              TextButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Text(
                  isArabic ? 'العودة للرئيسية' : 'Return to Home',
                  style: const TextStyle(color: Color(0xFF9B8EC7), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
      ),
    );
  }
}