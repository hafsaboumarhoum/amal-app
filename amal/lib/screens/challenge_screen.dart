import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/card_service.dart';
import 'challenge_result_screen.dart';

class ChallengeScreen extends StatefulWidget {
  final String language;
  const ChallengeScreen({super.key, required this.language});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();
  List<VocabCard> _allCards = [];
  int _currentQuestion = 0;
  int _score = 0;
  int _totalQuestions = 10;
  VocabCard? _correctCard;
  List<VocabCard> _options = [];
  String? _selectedAnswer;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    _allCards = await CardService.loadCards();
    if (_allCards.length < 3) return;
    _totalQuestions = _allCards.length >= 10 ? 10 : _allCards.length;
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentQuestion >= _totalQuestions) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChallengeResultScreen(
            score: _score,
            total: _totalQuestions,
            language: widget.language,
          ),
        ),
      );
      return;
    }

    final shuffled = List<VocabCard>.from(_allCards)..shuffle(_random);
    _correctCard = shuffled[0];
    final wrongs = shuffled.where((c) => c.id != _correctCard!.id).take(2).toList();
    _options = [_correctCard!, ...wrongs]..shuffle(_random);
    _selectedAnswer = null;
    _selectedIndex = null;
    setState(() {});

    Future.delayed(const Duration(milliseconds: 300), () => _playCurrentWord());
  }

  Future<void> _playCurrentWord() async {
    if (_correctCard == null) return;
    final path = widget.language == 'ar'
        ? _correctCard!.audioArabicPath
        : _correctCard!.audioEnglishPath;
    await _player.stop();
    await _player.play(AssetSource(path.replaceFirst('assets/', '')));
  }

  void _onAnswerTap(int index) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedIndex = index;
      if (_options[index].id == _correctCard!.id) {
        _selectedAnswer = 'correct';
        _score++;
      } else {
        _selectedAnswer = 'wrong';
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _currentQuestion++;
        _nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';

    if (_correctCard == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2EAE0),
        body: Center(
            child: CircularProgressIndicator(color: Color(0xFFBDA6CE))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'تحدي الصوت' : 'Audio Challenge'),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                '${_currentQuestion + 1}/$_totalQuestions | $_score ⭐',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _playCurrentWord,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDA6CE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.volume_up,
                    size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'اضغط للاستماع' : 'Tap to listen',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final card = _options[index];
                  final isCorrect = card.id == _correctCard!.id;
                  Color? borderColor;
                  if (_selectedAnswer != null) {
                    if (isCorrect) {
                      borderColor = const Color(0xFFB4D3D9);
                    } else if (_selectedIndex == index) {
                      borderColor = const Color(0xFF9B8EC7);
                    }
                  }
                  return GestureDetector(
                    onTap: () => _onAnswerTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: borderColor != null
                            ? Border.all(color: borderColor, width: 4)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          card.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFB4D3D9).withOpacity(0.2),
                            child: Center(child: Text(card.wordEnglish)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}