import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/card_service.dart';

class CardDetailScreen extends StatefulWidget {
  final VocabCard card;
  final String language;

  const CardDetailScreen({
    super.key,
    required this.card,
    required this.language,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.card;

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6398A9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                c.imagePath,
                height: 220,
                width: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  width: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              c.wordArabic,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              c.wordEnglish,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _playAudio(c.audioArabicPath),
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع بالعربية', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6398A9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _playAudio(c.audioEnglishPath),
              icon: const Icon(Icons.volume_up),
              label: const Text('Listen in English', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6398A9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mic recording coming next week!')),
                );
              },
              icon: const Icon(Icons.mic),
              label: Text(
                widget.language == 'ar' ? 'كرر بعدي' : 'Repeat After Me',
                style: const TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}