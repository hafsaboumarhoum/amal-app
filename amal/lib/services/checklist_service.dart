import 'dart:convert';
import 'package:flutter/services.dart';

class ChecklistItem {
  final String ageGroup;
  final String signEnglish;
  final String signArabic;

  ChecklistItem({
    required this.ageGroup,
    required this.signEnglish,
    required this.signArabic,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      ageGroup: json['age_group'],
      signEnglish: json['sign_english'],
      signArabic: json['sign_arabic'],
    );
  }
}

class ChecklistService {
  static List<ChecklistItem>? _cache;

  static Future<List<ChecklistItem>> loadItems() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(
      'assets/data/checklist_items.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    _cache = jsonList.map((j) => ChecklistItem.fromJson(j)).toList();
    return _cache!;
  }

  static List<String> get ageGroups => ['0-12m', '12-24m', '24-36m'];

  static Map<String, String> ageGroupArabic = {
    '0-12m': '٠-١٢ شهراً',
    '12-24m': '١٢-٢٤ شهراً',
    '24-36m': '٢٤-٣٦ شهراً',
  };
}