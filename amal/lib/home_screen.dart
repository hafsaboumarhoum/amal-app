import 'package:flutter/material.dart';
import 'package:amal/screens/specialist_directory_screen.dart';
import 'package:amal/screens/daily_guide_screen.dart';

class HomeScreen extends StatelessWidget {
  final String language;
  const HomeScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    final features = [
      {
        'icon': Icons.image,
        'title_ar': 'المكتبة البصرية',
        'title_en': 'Visual Library',
        'color': const Color(0xFF6398A9),
      },
      {
        'icon': Icons.quiz,
        'title_ar': 'تحدي الصوت',
        'title_en': 'Audio Challenge',
        'color': const Color(0xFF6398A9),
      },
      {
        'icon': Icons.local_hospital,
        'title_ar': 'دليل المختصين',
        'title_en': 'Specialist Directory',
        'color': const Color(0xFFD7897F),
      },
      {
        'icon': Icons.lightbulb,
        'title_ar': 'نصائح يومية',
        'title_en': 'Daily Guide',
        'color': const Color(0xFFF9B95C),
      },
      {
        'icon': Icons.checklist,
        'title_ar': 'قائمة العلامات المبكرة',
        'title_en': 'Early Signs Checklist',
        'color': const Color(0xFF96C7B3),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'أمل' : 'AMAL'),
        backgroundColor: const Color(0xFF6398A9),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(language: isArabic ? 'en' : 'ar'),
                ),
              );
            },
            child: Text(
              isArabic ? 'EN' : 'عربي',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: features.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final f = features[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  backgroundColor: (f['color'] as Color).withOpacity(0.15),
                  child: Icon(
                    f['icon'] as IconData,
                    color: f['color'] as Color,
                  ),
                ),
                title: Text(
                  isArabic ? f['title_ar'] as String : f['title_en'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (index == 2) {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => SpecialistDirectoryScreen(language: language),
  ));
} else if (index == 3) {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => DailyGuideScreen(language: language),
  ));
}

                  // index 0: Visual Library — Coder A wires this
                  // index 1: Audio Challenge — Coder B wires this
                  // index 3: Daily Guide — Coder C wires this
                  // index 4: Checklist — Coder A wires this
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
