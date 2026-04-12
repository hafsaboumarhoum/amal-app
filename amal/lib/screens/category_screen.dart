import 'package:flutter/material.dart';
import '../services/card_service.dart';
import 'card_grid_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String language;

  const CategoryScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
    final categories = CardService.categories;

    final categoryIcons = {
      'Food': Icons.restaurant,
      'Animals': Icons.pets,
      'Emotions': Icons.emoji_emotions,
      'Daily Life': Icons.home,
      'Colors': Icons.palette,
      'Numbers': Icons.looks_one,
    };

    final categoryColors = {
      'Food': const Color(0xFFB4D3D9),
      'Animals': const Color(0xFFBDA6CE),
      'Emotions': const Color(0xFF9B8EC7),
      'Daily Life': const Color(0xFFB4D3D9),
      'Colors': const Color(0xFFBDA6CE),
      'Numbers': const Color(0xFF9B8EC7),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'المكتبة البصرية' : 'Visual Library'),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: categories.map((cat) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardGridScreen(
                      category: cat,
                      language: language,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: categoryColors[cat],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categoryIcons[cat],
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isArabic
                          ? CardService.categoryArabic[cat]!
                          : cat,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}