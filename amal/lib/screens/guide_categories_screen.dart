import 'package:flutter/material.dart';
import 'guide_articles_list_screen.dart';
class GuideCategoriesScreen extends StatelessWidget {
  final String language;
  const GuideCategoriesScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    final categories = [
      {'en': 'Understanding Autism', 'ar': 'فهم التوحد', 'icon': Icons.psychology, 'color': const Color(0xFF6398A9)},
      {'en': 'Daily Life & Care', 'ar': 'الحياة اليومية والرعاية', 'icon': Icons.home, 'color': const Color(0xFF96C7B3)},
      {'en': 'Education & Therapy', 'ar': 'التعليم والعلاج', 'icon': Icons.school, 'color': const Color(0xFFF9B95C)},
      {'en': 'Health & Wellbeing', 'ar': 'الصحة والرفاهية', 'icon': Icons.favorite, 'color': const Color(0xFFD7897F)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'دليل الدعم اليومي' : 'Daily Support Guide'),
        backgroundColor: const Color(0xFFF9B95C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
children: [
            // Favorites button at top
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFD7897F),
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
                title: Text(
                  isArabic ? 'المقالات المحفوظة' : 'Saved Articles',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GuideArticlesListScreen(
                      category: 'Favorites',
                      language: language,
                    ),
                  ));
                },
              ),
            ),
            const SizedBox(height: 16),
            // 4 category cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => GuideArticlesListScreen(
                          category: cat['en'] as String,
                          language: language,
                        ),
                      ));
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: cat['color'] as Color,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'] as IconData, size: 48, color: Colors.white),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              isArabic ? cat['ar'] as String : cat['en'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
