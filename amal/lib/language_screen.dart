import 'package:flutter/material.dart';
import 'home_screen.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      body: Column(
        children: [
          // Puzzle characters on top
          Expanded(
            child: CustomPaint(
              painter: SeparatePuzzlePainter(),
              child: Container(),
            ),
          ),

          // Bottom section
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFB4D3D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              children: [
                const Text(
                  'إختر اللغة المناسبة لك',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _langButton(context, '🇲🇦  العربية', 'ar'),
                const SizedBox(height: 12),
                _langButton(context, '🇬🇧  الإنجليزية', 'en'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langButton(BuildContext context, String label, String lang) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2EAE0),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(language: lang),
            ),
          );
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF6B6B6B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SeparatePuzzlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final ps = size.width * 0.28;

    // Top-left — Blue
    paint.color = const Color(0xFFB4D3D9);
    _drawChar(canvas, paint, Offset(size.width * 0.25, size.height * 0.28), ps, true, false, false, true, FaceType.happy);

    // Top-right — Teal
    paint.color = const Color(0xFFADD0C8);
    _drawChar(canvas, paint, Offset(size.width * 0.72, size.height * 0.22), ps * 0.9, false, true, true, false, FaceType.neutral);

    // Bottom-left — Pink
    paint.color = const Color(0xFFD4A5A0);
    _drawChar(canvas, paint, Offset(size.width * 0.25, size.height * 0.68), ps, false, true, false, false, FaceType.glasses);

    // Bottom-right — Yellow
    paint.color = const Color(0xFFE8C88A);
    _drawChar(canvas, paint, Offset(size.width * 0.72, size.height * 0.68), ps * 0.9, true, false, false, true, FaceType.sad);
  }

  void _drawChar(Canvas canvas, Paint paint, Offset center, double size,
      bool tabTop, bool tabRight, bool tabBottom, bool tabLeft, FaceType face) {
    final r = size * 0.15;
    final tab = size * 0.18;

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size, height: size),
        Radius.circular(r),
      ),
      paint,
    );

    // Tabs
    if (tabTop) canvas.drawCircle(Offset(center.dx, center.dy - size / 2), tab, paint);
    if (tabRight) canvas.drawCircle(Offset(center.dx + size / 2, center.dy), tab, paint);
    if (tabBottom) canvas.drawCircle(Offset(center.dx, center.dy + size / 2), tab, paint);
    if (tabLeft) canvas.drawCircle(Offset(center.dx - size / 2, center.dy), tab, paint);

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx - size * 0.2, center.dy + size / 2 + 10), width: 10, height: 18),
        const Radius.circular(5),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + size * 0.2, center.dy + size / 2 + 10), width: 10, height: 18),
        const Radius.circular(5),
      ),
      paint,
    );

    // Face
    final white = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final dark = Paint()..color = const Color(0xFF555555)..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(center.dx - size * 0.16, center.dy - size * 0.08), 4.5, white);
    canvas.drawCircle(Offset(center.dx + size * 0.16, center.dy - size * 0.08), 4.5, white);
    canvas.drawCircle(Offset(center.dx - size * 0.16, center.dy - size * 0.08), 2.2, dark);
    canvas.drawCircle(Offset(center.dx + size * 0.16, center.dy - size * 0.08), 2.2, dark);

    if (face == FaceType.happy) {
      final path = Path();
      path.moveTo(center.dx - 10, center.dy + size * 0.1);
      path.quadraticBezierTo(center.dx, center.dy + size * 0.2, center.dx + 10, center.dy + size * 0.1);
      canvas.drawPath(path, stroke);
    } else if (face == FaceType.sad) {
      final path = Path();
      path.moveTo(center.dx - 10, center.dy + size * 0.18);
      path.quadraticBezierTo(center.dx, center.dy + size * 0.1, center.dx + 10, center.dy + size * 0.18);
      canvas.drawPath(path, stroke);
    } else if (face == FaceType.neutral) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx, center.dy + size * 0.14), width: 16, height: 5),
          const Radius.circular(3),
        ),
        white,
      );
    } else if (face == FaceType.glasses) {
      final g = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.8;
      canvas.drawCircle(Offset(center.dx - size * 0.16, center.dy - size * 0.08), 6, g);
      canvas.drawCircle(Offset(center.dx + size * 0.16, center.dy - size * 0.08), 6, g);
      canvas.drawLine(
        Offset(center.dx - size * 0.16 + 6, center.dy - size * 0.08),
        Offset(center.dx + size * 0.16 - 6, center.dy - size * 0.08),
        g,
      );
      final path = Path();
      path.moveTo(center.dx - 10, center.dy + size * 0.1);
      path.quadraticBezierTo(center.dx, center.dy + size * 0.2, center.dx + 10, center.dy + size * 0.1);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  
}enum FaceType { happy, sad, neutral, glasses }