import 'package:flutter/material.dart';
import 'challenge_screen.dart';
import 'show_me_screen.dart';

class ChallengeResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String language;

  const ChallengeResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.language,
  });

  int get _stars {
    final pct = score / total;
    if (pct >= 0.8) return 3;
    if (pct >= 0.5) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    i < _stars ? Icons.star : Icons.star_border,
                    size: 60,
                    color: const Color(0xFFBDA6CE),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text(
                '$score / $total',
                style: const TextStyle(
                    fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'أحسنت!' : 'Great job!',
                style: const TextStyle(
                    fontSize: 24, color: Color(0xFFB4D3D9)),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChallengeScreen(language: language),
                    ),
                  );
                },
                icon: const Icon(Icons.replay),
                label: Text(isArabic ? 'العب مرة أخرى' : 'Play Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4D3D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowMeScreen(language: language),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: Text(isArabic ? 'جرب أرني!' : 'Try Show Me!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBDA6CE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  isArabic ? 'العودة للرئيسية' : 'Back to Home',
                  style: const TextStyle(color: Color(0xFF9B8EC7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}