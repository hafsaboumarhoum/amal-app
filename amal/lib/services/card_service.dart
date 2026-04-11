import 'dart:convert';
import 'package:flutter/services.dart';

class VocabCard {
  final String id;
  final String wordArabic;
  final String wordEnglish;
  final String imagePath;
  final String audioArabicPath;
  final String audioEnglishPath;
  final String category;
  final int difficultyLevel;
  final List<String> mlLabels;

  VocabCard({
    required this.id,
    required this.wordArabic,
    required this.wordEnglish,
    required this.imagePath,
    required this.audioArabicPath,
    required this.audioEnglishPath,
    required this.category,
    required this.difficultyLevel,
    required this.mlLabels,
  });

  factory VocabCard.fromJson(Map<String, dynamic> json) {
    return VocabCard(
      id: json['id'],
      wordArabic: json['word_arabic'],
      wordEnglish: json['word_english'],
      imagePath: json['image_path'],
      audioArabicPath: json['audio_arabic_path'],
      audioEnglishPath: json['audio_english_path'],
      category: json['category'],
      difficultyLevel: json['difficulty_level'],
      mlLabels: List<String>.from(json['ml_labels'] ?? []),
    );
  }
}

class CardService {
  static List<VocabCard>? _cache;

  static Future<List<VocabCard>> loadCards() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(
      'assets/data/vocabulary_cards.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    _cache = jsonList.map((j) => VocabCard.fromJson(j)).toList();
    return _cache!;
  }

  static Future<List<VocabCard>> getByCategory(String category) async {
    final all = await loadCards();
    return all.where((c) => c.category == category).toList();
  }

  static List<String> get categories =>
    ['Food', 'Animals', 'Emotions', 'Daily Life', 'Colors', 'Numbers'];

  static Map<String, String> categoryArabic = {
    'Food': 'طعام',
    'Animals': 'حيوانات',
    'Emotions': 'مشاعر',
    'Daily Life': 'حياة يومية',
    'Colors': 'ألوان',
    'Numbers': 'أرقام',
  };
}
