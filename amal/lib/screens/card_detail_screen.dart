import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
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
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  int _practiceCount = 0;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _loadPracticeCount();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _loadPracticeCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _practiceCount = prefs.getInt('practice_${widget.card.id}') ?? 0;
    });
  }

  Future<void> _incrementPractice() async {
    final prefs = await SharedPreferences.getInstance();
    _practiceCount++;
    await prefs.setInt('practice_${widget.card.id}', _practiceCount);
    setState(() {});
  }

  Future<void> _speakArabic() async {
    await _tts.setLanguage('ar-SA');
    await _tts.speak(widget.card.wordArabic);
    _incrementPractice();
  }

  Future<void> _speakEnglish() async {
    await _tts.setLanguage('en-US');
    await _tts.speak(widget.card.wordEnglish);
    _incrementPractice();
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/recording_${widget.card.id}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopAndPlayRecording() async {
    final path = await _recorder.stop();
    setState(() => _isRecording = false);
    if (path != null && File(path).existsSync()) {
      await _player.play(DeviceFileSource(path));
      _incrementPractice();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.card;
    final isArabic = widget.language == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB4D3D9),
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
                  color: const Color(0xFFB4D3D9).withOpacity(0.2),
                  child: const Icon(Icons.image,
                      size: 80, color: Color(0xFFB4D3D9)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isArabic
                  ? 'تم التدرب $_practiceCount مرة'
                  : 'Practiced $_practiceCount times',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              c.wordArabic,
              style: const TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              c.wordEnglish,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _speakArabic,
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع بالعربية',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4D3D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _speakEnglish,
              icon: const Icon(Icons.volume_up),
              label: const Text('Listen in English',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4D3D9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isRecording ? _stopAndPlayRecording : _startRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(
                _isRecording
                    ? (isArabic
                        ? 'اضغط للإيقاف والاستماع'
                        : 'Tap to stop & listen')
                    : (isArabic ? 'كرر بعدي' : 'Repeat After Me'),
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isRecording ? Colors.red : const Color(0xFFBDA6CE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
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