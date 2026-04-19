import 'package:flutter/material.dart';
import '../services/guide_service.dart';

class DailyGuideScreen extends StatelessWidget {
  final String language;

  const DailyGuideScreen({super.key, required this.language});

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'info': return Icons.info_outline;
      case 'visibility': return Icons.visibility;
      case 'medical_services': return Icons.medical_services;
      case 'science': return Icons.science;
      case 'home': return Icons.home;
      case 'chat': return Icons.chat_bubble_outline;
      case 'hearing': return Icons.hearing;
      case 'people': return Icons.people;
      case 'healing': return Icons.healing;
      case 'psychology': return Icons.psychology;
      default: return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'النصائح اليومية' : 'Daily Guide'),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<GuideItem>>(
        future: GuideService.loadItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFBDA6CE)),
            );
          }
          final items = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFB4D3D9).withOpacity(0.2),
                    child: Icon(
                      _getIcon(item.icon),
                      color: const Color(0xFFB4D3D9),
                    ),
                  ),
                  title: Text(
                    isArabic ? item.titleAr : item.titleEn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        isArabic ? item.contentAr : item.contentEn,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xFF444444),
                        ),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}