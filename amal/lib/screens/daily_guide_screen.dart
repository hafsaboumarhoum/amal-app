import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'all_tips_screen.dart';

class DailyGuideScreen extends StatefulWidget {
  final String language;
  const DailyGuideScreen({super.key, required this.language});

  @override
  State<DailyGuideScreen> createState() => _DailyGuideScreenState();
}
class _DailyGuideScreenState extends State<DailyGuideScreen> {
  Map<String, dynamic>? _todaysTip;

  @override
  void initState() {
    super.initState();
    _loadTip();
  }

  Future<void> _loadTip() async {
    final jsonStr = await rootBundle.loadString('assets/data/daily_tips.json');
    final List<dynamic> tips = json.decode(jsonStr);
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;
final tipIndex = dayOfYear % tips.length;
    setState(() => _todaysTip = tips[tipIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'نصائح يومية' : 'Daily Guide'),
        backgroundColor: const Color(0xFFF9B95C),
        foregroundColor: Colors.white,
      ),
      body: _todaysTip == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Category badge
              Chip(
                label: Text(
                  _todaysTip!['category'],
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFF9B95C),
              ),
const SizedBox(height: 16),
              // Tip card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        isArabic ? _todaysTip!['tip_arabic'] : _todaysTip!['tip_english'],
                        style: const TextStyle(fontSize: 20, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '💡 ${_todaysTip!['activity_suggestion']}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Read Aloud (placeholder — TTS API Week 3)
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Read Aloud coming next week!')),
                  );
                },
                icon: const Icon(Icons.volume_up),
                label: Text(isArabic ? 'اقرأ بصوت عالٍ' : 'Read Aloud'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9B95C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              // Favorites (placeholder — Week 3)
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                label: Text(isArabic ? 'حفظ في المفضلة' : 'Save to Favorites'),
              ),
              const SizedBox(height: 24),
              // Browse All
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AllTipsScreen(language: widget.language),
                  ));
                },
                child: Text(isArabic ? 'تصفح جميع النصائح' : 'Browse All Tips'),
              ),
            ],
          ),
        ),
    );
  }
}

