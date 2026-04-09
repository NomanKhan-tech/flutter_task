import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// Mood data model
class MoodEntry {
  final String name;
  final Color faceColor;
  final Color faceAccent;
  final _FaceExpression expression;
  final double angle; // radians, where 0 = right (3 o'clock), goes clockwise

  const MoodEntry({
    required this.name,
    required this.faceColor,
    required this.faceAccent,
    required this.expression,
    required this.angle,
  });
}

enum _FaceExpression { calm, content, happy, excited, anxious, sad, angry }

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  // Angle of the handle (in radians). 0 = 3 o'clock, increases clockwise.
  // Calm is at ~315° (top-right area), Content is at ~45° lower-right area
  double _handleAngle = -0.8; // roughly "Calm" position (upper right)

  static const List<MoodEntry> _moods = [
    MoodEntry(
      name: 'Calm',
      faceColor: Color(0xFFE8C4A8),
      faceAccent: Color(0xFFD4896A),
      expression: _FaceExpression.calm,
      angle: -0.8,
    ),
    MoodEntry(
      name: 'Content',
      faceColor: Color(0xFFF5C842),
      faceAccent: Color(0xFF2C2C2E),
      expression: _FaceExpression.content,
      angle: 0.8,
    ),
    MoodEntry(
      name: 'Happy',
      faceColor: Color(0xFFF5C842),
      faceAccent: Color(0xFF2C2C2E),
      expression: _FaceExpression.happy,
      angle: 1.6,
    ),
    MoodEntry(
      name: 'Anxious',
      faceColor: Color(0xFFE8A0A8),
      faceAccent: Color(0xFF8B2A2A),
      expression: _FaceExpression.anxious,
      angle: 2.4,
    ),
    MoodEntry(
      name: 'Sad',
      faceColor: Color(0xFFB8C8E8),
      faceAccent: Color(0xFF2A4A8B),
      expression: _FaceExpression.sad,
      angle: -2.4,
    ),
    MoodEntry(
      name: 'Excited',
      faceColor: Color(0xFFF5C842),
      faceAccent: Color(0xFF2C2C2E),
      expression: _FaceExpression.excited,
      angle: -1.6,
    ),
  ];

  MoodEntry get _currentMood {
    // Find closest mood to current angle
    MoodEntry closest = _moods.first;
    double minDist = double.infinity;
    for (final mood in _moods) {
      double dist = (_normalizeAngle(_handleAngle) - _normalizeAngle(mood.angle)).abs();
      if (dist > math.pi) dist = 2 * math.pi - dist;
      if (dist < minDist) {
        minDist = dist;
        closest = mood;
      }
    }
    return closest;
  }

  double _normalizeAngle(double angle) {
    while (angle < 0) angle += 2 * math.pi;
    while (angle >= 2 * math.pi) angle -= 2 * math.pi;
    return angle;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset center) {
    final dx = details.globalPosition.dx - center.dx;
    final dy = details.globalPosition.dy - center.dy;
    setState(() {
      _handleAngle = math.atan2(dy, dx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mood = _currentMood;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Mood',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Start your day',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'How are you feeling at the\nMoment?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 32),
              // Mood wheel
              Expanded(
                child: Center(
                  child: _MoodWheel(
                    handleAngle: _handleAngle,
                    mood: mood,
                    onPanUpdate: _onPanUpdate,
                  ),
                ),
              ),
              // Mood name
              const SizedBox(height:30),

              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    mood.name,
                    key: ValueKey(mood.name),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: AppColors.backgroundPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodWheel extends StatelessWidget {
  final double handleAngle;
  final MoodEntry mood;
  final void Function(DragUpdateDetails, Offset) onPanUpdate;

  const _MoodWheel({
    required this.handleAngle,
    required this.mood,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = math.min(constraints.maxWidth, constraints.maxHeight);
      final center = Offset(size / 2, size / 2);

      return GestureDetector(
        onPanUpdate: (details) {
          // Convert local to global for angle calculation
          final RenderBox box = context.findRenderObject() as RenderBox;
          final globalCenter = box.localToGlobal(center);
          onPanUpdate(details, globalCenter);
        },
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gradient wheel ring
              CustomPaint(
                size: Size(size, size),
                painter: _WheelPainter(handleAngle: handleAngle),
              ),
              // Emoji face in center
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _EmojiFace(
                  key: ValueKey(mood.name),
                  mood: mood,
                  size: size * 0.48,
                ),
              ),
              // Draggable handle dot
              _HandleDot(
                angle: handleAngle,
                radius: size * 0.53,
                center: center,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _WheelPainter extends CustomPainter {
  final double handleAngle;

  const _WheelPainter({required this.handleAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.60;
    final innerRadius = size.width * 0.47;
    final strokeWidth = outerRadius - innerRadius;
    final paintRadius = innerRadius + strokeWidth / 2;

    // Draw segmented arc (12 segments)
    const segmentCount = 12;
    const gapAngle = 0.02; // radians between segments
    final segmentAngle = (2 * math.pi / segmentCount) - gapAngle;

    // Color gradient for the wheel going from teal -> lavender -> pink -> peach -> orange -> teal
    final gradientColors = [
      const Color(0xFF5ECFBA), // teal
      const Color(0xFF7BBAE8), // sky blue
      const Color(0xFF8B7EE8), // periwinkle
      const Color(0xFFB388D8), // lavender
      const Color(0xFFD4A0C8), // mauve
      const Color(0xFFE8A0A8), // pink
      const Color(0xFFF0B0A0), // salmon
      const Color(0xFFF0C890), // peach
      const Color(0xFFE8A850), // amber
      const Color(0xFFD49040), // orange
      const Color(0xFFB8A870), // gold
      const Color(0xFF5ECFBA), // back to teal
    ];

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = (2 * math.pi / segmentCount) * i - math.pi / 2;
      final color = gradientColors[i % gradientColors.length];

      final paint = Paint()
        ..color = color.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: paintRadius),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.handleAngle != handleAngle;
}

class _HandleDot extends StatelessWidget {
  final double angle;
  final double radius;
  final Offset center;

  const _HandleDot({
    required this.angle,
    required this.radius,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    final x = center.dx + radius * math.cos(angle) - center.dx;
    final y = center.dy + radius * math.sin(angle) - center.dy;

    return Transform.translate(
      offset: Offset(x, y),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFCCEEE8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiFace extends StatelessWidget {
  final MoodEntry mood;
  final double size;

  const _EmojiFace({super.key, required this.mood, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: mood.faceColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: mood.faceColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _FacePainter(
          mood: mood,
          accentColor: mood.faceAccent,
        ),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  final MoodEntry mood;
  final Color accentColor;

  const _FacePainter({required this.mood, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()..color = accentColor;

    switch (mood.expression) {
      case _FaceExpression.calm:
        _drawCalmFace(canvas, cx, cy, size, paint);
        break;
      case _FaceExpression.content:
      case _FaceExpression.happy:
        _drawHappyFace(canvas, cx, cy, size, paint);
        break;
      case _FaceExpression.excited:
        _drawExcitedFace(canvas, cx, cy, size, paint);
        break;
      case _FaceExpression.anxious:
        _drawAnxiousFace(canvas, cx, cy, size, paint);
        break;
      case _FaceExpression.sad:
        _drawSadFace(canvas, cx, cy, size, paint);
        break;
      case _FaceExpression.angry:
        _drawAngryFace(canvas, cx, cy, size, paint);
        break;
    }
  }

  void _drawCalmFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    final eyePaint = Paint()..color = accentColor..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // Closed happy eyes (curved lines)
    final leftEyePath = Path()
      ..moveTo(cx - size.width * 0.18, cy - size.height * 0.08)
      ..quadraticBezierTo(cx - size.width * 0.12, cy - size.height * 0.16, cx - size.width * 0.06, cy - size.height * 0.08);
    final rightEyePath = Path()
      ..moveTo(cx + size.width * 0.06, cy - size.height * 0.08)
      ..quadraticBezierTo(cx + size.width * 0.12, cy - size.height * 0.16, cx + size.width * 0.18, cy - size.height * 0.08);

    canvas.drawPath(leftEyePath, eyePaint);
    canvas.drawPath(rightEyePath, eyePaint);

    // Rosy cheeks
    final cheekPaint = Paint()..color = const Color(0xFFE8708A).withOpacity(0.6);
    canvas.drawCircle(Offset(cx - size.width * 0.22, cy + size.height * 0.05), size.width * 0.08, cheekPaint);
    canvas.drawCircle(Offset(cx + size.width * 0.22, cy + size.height * 0.05), size.width * 0.08, cheekPaint);

    // Small "o" mouth
    final mouthPaint = Paint()..color = accentColor..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + size.height * 0.15), size.width * 0.05, mouthPaint);
  }

  void _drawHappyFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    final eyePaint = Paint()..color = accentColor..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // Closed happy curved eyes
    final leftEyePath = Path()
      ..moveTo(cx - size.width * 0.2, cy - size.height * 0.08)
      ..quadraticBezierTo(cx - size.width * 0.12, cy - size.height * 0.18, cx - size.width * 0.04, cy - size.height * 0.08);
    final rightEyePath = Path()
      ..moveTo(cx + size.width * 0.04, cy - size.height * 0.08)
      ..quadraticBezierTo(cx + size.width * 0.12, cy - size.height * 0.18, cx + size.width * 0.2, cy - size.height * 0.08);

    canvas.drawPath(leftEyePath, eyePaint);
    canvas.drawPath(rightEyePath, eyePaint);

    // Big smile
    final smilePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(cx - size.width * 0.2, cy + size.height * 0.06)
      ..quadraticBezierTo(cx, cy + size.height * 0.22, cx + size.width * 0.2, cy + size.height * 0.06);
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawExcitedFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    // Star-shaped eyes
    final eyePaint = Paint()..color = accentColor..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(cx - size.width * 0.14, cy - size.height * 0.1), size.width * 0.06, eyePaint);
    _drawStar(canvas, Offset(cx + size.width * 0.14, cy - size.height * 0.1), size.width * 0.06, eyePaint);
    // Big open smile
    final smilePaint = Paint()..color = accentColor..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(cx - size.width * 0.2, cy + size.height * 0.04)
      ..quadraticBezierTo(cx, cy + size.height * 0.22, cx + size.width * 0.2, cy + size.height * 0.04);
    canvas.drawPath(smilePath, smilePaint);
  }

  void _drawAnxiousFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    // Wide oval eyes
    final eyePaint = Paint()..color = accentColor..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - size.width * 0.15, cy - size.height * 0.1), width: size.width * 0.1, height: size.height * 0.14), eyePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + size.width * 0.15, cy - size.height * 0.1), width: size.width * 0.1, height: size.height * 0.14), eyePaint);
    // Wavy worried mouth
    final mouthPaint = Paint()..color = accentColor..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final mouthPath = Path()
      ..moveTo(cx - size.width * 0.18, cy + size.height * 0.12)
      ..quadraticBezierTo(cx - size.width * 0.08, cy + size.height * 0.06, cx, cy + size.height * 0.12)
      ..quadraticBezierTo(cx + size.width * 0.08, cy + size.height * 0.18, cx + size.width * 0.18, cy + size.height * 0.12);
    canvas.drawPath(mouthPath, mouthPaint);
  }

  void _drawSadFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    final eyePaint = Paint()..color = accentColor..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // Droopy eyes
    canvas.drawLine(Offset(cx - size.width * 0.2, cy - size.height * 0.1), Offset(cx - size.width * 0.08, cy - size.height * 0.1), eyePaint);
    canvas.drawLine(Offset(cx + size.width * 0.08, cy - size.height * 0.1), Offset(cx + size.width * 0.2, cy - size.height * 0.1), eyePaint);
    // Frown
    final frownPaint = Paint()..color = accentColor..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final frownPath = Path()
      ..moveTo(cx - size.width * 0.2, cy + size.height * 0.16)
      ..quadraticBezierTo(cx, cy + size.height * 0.06, cx + size.width * 0.2, cy + size.height * 0.16);
    canvas.drawPath(frownPath, frownPaint);
  }

  void _drawAngryFace(Canvas canvas, double cx, double cy, Size size, Paint paint) {
    final eyePaint = Paint()..color = accentColor..style = PaintingStyle.fill;
    // Angled eyebrows
    final browPaint = Paint()..color = accentColor..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - size.width * 0.2, cy - size.height * 0.18), Offset(cx - size.width * 0.06, cy - size.height * 0.12), browPaint);
    canvas.drawLine(Offset(cx + size.width * 0.06, cy - size.height * 0.12), Offset(cx + size.width * 0.2, cy - size.height * 0.18), browPaint);
    // Eyes
    canvas.drawCircle(Offset(cx - size.width * 0.14, cy - size.height * 0.04), size.width * 0.04, eyePaint);
    canvas.drawCircle(Offset(cx + size.width * 0.14, cy - size.height * 0.04), size.width * 0.04, eyePaint);
    // Frown
    final frownPaint = Paint()..color = accentColor..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final frownPath = Path()
      ..moveTo(cx - size.width * 0.18, cy + size.height * 0.16)
      ..quadraticBezierTo(cx, cy + size.height * 0.06, cx + size.width * 0.18, cy + size.height * 0.16);
    canvas.drawPath(frownPath, frownPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FacePainter old) => old.mood != mood;
}
