import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/record.dart';
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
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  int _practiceCount = 0;
  bool _isRecording = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _loadPracticeCount();
  }

  @override
  void dispose() {
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

  Future<void> _playAudio(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
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
        _recordingPath = path;
      });
    }
  }

  Future<void> _stopAndPlayRecording() async {
  final path = await _recorder.stop();
  setState(() => _isRecording = false);
  debugPrint('Recording path: $path');
  if (path != null && File(path).existsSync()) {
    debugPrint('File exists, playing...');
    await _player.play(DeviceFileSource(path));
    _incrementPractice();
  } else {
    debugPrint('File not found at path: $path');
  }
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
            const SizedBox(height: 12),
            Text(
              widget.language == 'ar'
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
              onPressed: () => _playAudio(c.audioArabicPath),
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع بالعربية',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6398A9),
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
              onPressed: () => _playAudio(c.audioEnglishPath),
              icon: const Icon(Icons.volume_up),
              label: const Text('Listen in English',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6398A9),
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
                    ? (widget.language == 'ar'
                        ? 'اضغط للإيقاف والاستماع'
                        : 'Tap to stop & listen')
                    : (widget.language == 'ar' ? 'كرر بعدي' : 'Repeat After Me'),
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isRecording ? Colors.red : const Color(0xFF96C7B3),
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