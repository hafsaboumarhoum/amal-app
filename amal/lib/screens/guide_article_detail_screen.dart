import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/tts_service.dart';
class GuideArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;
  final String language;
  const GuideArticleDetailScreen({super.key, required this.article, required this.language});

  @override
  State<GuideArticleDetailScreen> createState() => _GuideArticleDetailScreenState();
}

class _GuideArticleDetailScreenState extends State<GuideArticleDetailScreen> {
  bool _isFavorite = false;
  bool _isReading = false;
  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_articles') ?? [];
    setState(() => _isFavorite = favs.contains(widget.article['id']));
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_articles') ?? [];
    final id = widget.article['id'];
    if (favs.contains(id)) { favs.remove(id); } else { favs.add(id); }
    await prefs.setStringList('favorite_articles', favs);
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    final question = isArabic ? widget.article['question_ar'] : widget.article['question_en'];
    final body = isArabic ? widget.article['article_ar'] : widget.article['article_en'];
final category = isArabic ? widget.article['category_ar'] : widget.article['category'];

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xFFF9B95C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(body, style: const TextStyle(fontSize: 17, height: 1.8)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
onPressed: () {
                  setState(() => _isReading = !_isReading);
                  if (_isReading) {
                    TtsService.speak(body, widget.language);
                  }
                },
                icon: Icon(_isReading ? Icons.stop : Icons.volume_up),
                label: Text(
                  _isReading
                    ? (isArabic ? 'إيقاف القراءة' : 'Stop Reading')
                    : (isArabic ? 'اقرأ بصوت عالٍ' : 'Read Aloud'),
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9B95C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
