import 'dart:convert';
import 'package:flutter/services.dart';

class GuideItem {
  final int id;
  final String titleEn;
  final String titleAr;
  final String contentEn;
  final String contentAr;
  final String icon;

  GuideItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.contentEn,
    required this.contentAr,
    required this.icon,
  });

  factory GuideItem.fromJson(Map<String, dynamic> json) {
    return GuideItem(
      id: json['id'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      contentEn: json['content_en'],
      contentAr: json['content_ar'],
      icon: json['icon'],
    );
  }
}

class GuideService {
  static Future<List<GuideItem>> loadItems() async {
    final String data =
        await rootBundle.loadString('assets/data/daily_guide.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => GuideItem.fromJson(e)).toList();
  }
}