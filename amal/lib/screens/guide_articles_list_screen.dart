import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'guide_article_detail_screen.dart';

class GuideArticlesListScreen extends StatefulWidget {
  final String category;
final String language;
  const GuideArticlesListScreen({super.key, required this.category, required this.language});

  @override
  State<GuideArticlesListScreen> createState() => _GuideArticlesListScreenState();
}

class _GuideArticlesListScreenState extends State<GuideArticlesListScreen> {
  List<Map<String, dynamic>> _articles = [];
  List<String> _favoriteIds = [];

  @override
  void initState() {
super.initState();
    _load();
  }

  Future<void> _load() async {
    final jsonStr = await rootBundle.loadString('assets/data/guide_articles.json');
    final List<dynamic> all = json.decode(jsonStr);
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favorite_articles') ?? [];

    setState(() {
      if (widget.category == 'Favorites') {
_articles = all.where((a) => _favoriteIds.contains(a['id'])).cast<Map<String, dynamic>>().toList();
      } else {
        _articles = all.where((a) => a['category'] == widget.category).cast<Map<String, dynamic>>().toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    final title = widget.category == 'Favorites'
      ? (isArabic ? 'المقالات المحفوظة' : 'Saved Articles')
: (isArabic ? _articles.isNotEmpty ? _articles.first['category_ar'] : '' : widget.category);

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF9B95C),
        foregroundColor: Colors.white,
      ),
      body: _articles.isEmpty
        ? Center(child: Text(
            isArabic ? 'لا توجد مقالات' : 'No articles yet',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _articles.length,
          itemBuilder: (context, index) {
            final article = _articles[index];
            final isFav = _favoriteIds.contains(article['id']);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  isArabic ? article['question_ar'] : article['question_en'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFD7897F),
                ),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GuideArticleDetailScreen(
                      article: article,
                      language: widget.language,
                    ),
                  ));
_load(); // Refresh favorites on return
                },
              ),
            );
          },
        ),
    );
  }
}
