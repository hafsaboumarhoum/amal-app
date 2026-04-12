import 'package:flutter/material.dart';
import 'language_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      body: Stack(
        children: [
          // Puzzle pieces at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: h * 0.50,
            child: CustomPaint(
              painter: ConnectedPuzzlePainter(),
            ),
          ),

          // Content on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bloom',
                      style: TextStyle(
                        fontSize: 76,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 127, 141, 189),
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'بلوم هو تطبيق مساعد لأطفال التوحد والأمهات ديالهم كيقدم العديد من المزايا',
                      style: TextStyle(
                        fontSize: 19,
                        color: Color(0xFF6B6B6B),
                        height: 1.7,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB4D3D9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 44, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'إبدأ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectedPuzzlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final pw = w / 2;
    final ph = h / 2;
    final tab = pw * 0.16;
    final r = 20.0;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Top-left — Blue
    paint.color = const Color(0xFFB4D3D9);
    _drawPiece(canvas, shadowPaint, 4, 4, pw, ph, r, tab,
        tabRight: true, tabBottom: true);
    _drawPiece(canvas, paint, 0, 0, pw, ph, r, tab,
        tabRight: true, tabBottom: true);
    _drawFace(canvas, Offset(pw * 0.48, ph * 0.48), pw * 0.32, FaceType.happy);

    // Top-right — Teal
    paint.color = const Color(0xFFADD0C8);
    _drawPiece(canvas, shadowPaint, pw + 4, 4, pw, ph, r, tab,
        indentLeft: true, tabBottom: false);
    _drawPiece(canvas, paint, pw, 0, pw, ph, r, tab,
        indentLeft: true, tabBottom: false);
    _drawFace(canvas, Offset(pw + pw * 0.52, ph * 0.48), pw * 0.32, FaceType.neutral);

    // Bottom-left — Pink
    paint.color = const Color(0xFFD4A5A0);
    _drawPiece(canvas, shadowPaint, 4, ph + 4, pw, ph, r, tab,
        indentTop: true, tabRight: false);
    _drawPiece(canvas, paint, 0, ph, pw, ph, r, tab,
        indentTop: true, tabRight: false);
    _drawFace(canvas, Offset(pw * 0.48, ph + ph * 0.5), pw * 0.32, FaceType.glasses);

    // Bottom-right — Yellow
    paint.color = const Color(0xFFE8C88A);
    _drawPiece(canvas, shadowPaint, pw + 4, ph + 4, pw, ph, r, tab,
        indentLeft: true, indentTop: true);
    _drawPiece(canvas, paint, pw, ph, pw, ph, r, tab,
        indentLeft: true, indentTop: true);
    _drawFace(canvas, Offset(pw + pw * 0.52, ph + ph * 0.5), pw * 0.32, FaceType.sad);
  }

  void _drawPiece(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double w,
    double h,
    double r,
    double tab, {
    bool tabRight = false,
    bool tabBottom = false,
    bool indentLeft = false,
    bool indentTop = false,
  }) {
    final path = Path();

    // Top edge
    path.moveTo(x + r, y);
    if (indentTop) {
      path.lineTo(x + w / 2 - tab * 1.1, y);
      path.arcToPoint(
        Offset(x + w / 2 + tab * 1.1, y),
        radius: Radius.circular(tab),
        clockwise: true,
      );
    }
    path.lineTo(x + w - r, y);
    path.arcToPoint(Offset(x + w, y + r),
        radius: Radius.circular(r), clockwise: true);

    // Right edge
    if (tabRight) {
      path.lineTo(x + w, y + h / 2 - tab * 1.1);
      path.arcToPoint(
        Offset(x + w, y + h / 2 + tab * 1.1),
        radius: Radius.circular(tab),
        clockwise: false,
      );
    }
    path.lineTo(x + w, y + h - r);
    path.arcToPoint(Offset(x + w - r, y + h),
        radius: Radius.circular(r), clockwise: true);

    // Bottom edge
    if (tabBottom) {
      path.lineTo(x + w / 2 + tab * 1.1, y + h);
      path.arcToPoint(
        Offset(x + w / 2 - tab * 1.1, y + h),
        radius: Radius.circular(tab),
        clockwise: false,
      );
    }
    path.lineTo(x + r, y + h);
    path.arcToPoint(Offset(x, y + h - r),
        radius: Radius.circular(r), clockwise: true);

    // Left edge
    if (indentLeft) {
      path.lineTo(x, y + h / 2 + tab * 1.1);
      path.arcToPoint(
        Offset(x, y + h / 2 - tab * 1.1),
        radius: Radius.circular(tab),
        clockwise: true,
      );
    }
    path.lineTo(x, y + r);
    path.arcToPoint(Offset(x + r, y),
        radius: Radius.circular(r), clockwise: true);

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawFace(Canvas canvas, Offset center, double size, FaceType type) {
    final white = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final dark = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Eyes
    canvas.drawCircle(
        Offset(center.dx - size * 0.22, center.dy - size * 0.12), 6, white);
    canvas.drawCircle(
        Offset(center.dx + size * 0.22, center.dy - size * 0.12), 6, white);
    canvas.drawCircle(
        Offset(center.dx - size * 0.22, center.dy - size * 0.12), 3, dark);
    canvas.drawCircle(
        Offset(center.dx + size * 0.22, center.dy - size * 0.12), 3, dark);

    if (type == FaceType.happy) {
      final path = Path();
      path.moveTo(center.dx - 16, center.dy + size * 0.1);
      path.quadraticBezierTo(
          center.dx, center.dy + size * 0.28, center.dx + 16, center.dy + size * 0.1);
      canvas.drawPath(path, stroke);
    } else if (type == FaceType.sad) {
      final path = Path();
      path.moveTo(center.dx - 16, center.dy + size * 0.25);
      path.quadraticBezierTo(
          center.dx, center.dy + size * 0.1, center.dx + 16, center.dy + size * 0.25);
      canvas.drawPath(path, stroke);
    } else if (type == FaceType.neutral) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(center.dx, center.dy + size * 0.16),
              width: 26,
              height: 8),
          const Radius.circular(4),
        ),
        white,
      );
    } else if (type == FaceType.glasses) {
      final g = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(
          Offset(center.dx - size * 0.22, center.dy - size * 0.12), 9, g);
      canvas.drawCircle(
          Offset(center.dx + size * 0.22, center.dy - size * 0.12), 9, g);
      canvas.drawLine(
        Offset(center.dx - size * 0.22 + 9, center.dy - size * 0.12),
        Offset(center.dx + size * 0.22 - 9, center.dy - size * 0.12),
        g,
      );
      final path = Path();
      path.moveTo(center.dx - 16, center.dy + size * 0.1);
      path.quadraticBezierTo(
          center.dx, center.dy + size * 0.28, center.dx + 16, center.dy + size * 0.1);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum FaceType { happy, sad, neutral, glasses }