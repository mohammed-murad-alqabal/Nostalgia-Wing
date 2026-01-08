import 'package:flutter/material.dart';
import 'dart:math' as math;

/// شعار الهوية المعرفي - Cognitive Mathematical Logo
/// رسم رياضي دقيق للهوية البصرية (جناح الحنين) باستخدام CustomPainter.
class CognitiveLogo extends StatelessWidget {
  /// Creates a [CognitiveLogo] with customizable size and color.
  const CognitiveLogo({
    super.key,
    this.size = 120,
    this.color = const Color(0xFFE4C1B1), // Rose Gold
    this.showGlow = true,
  });

  /// Size of the logo (width and height).
  final double size;

  /// Primary color of the logo stroke.
  final Color color;

  /// Whether to show the outer glow effect.
  final bool showGlow;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _WingHeartPainter(
            color: color,
            showGlow: showGlow,
          ),
        ),
      );
}

class _WingHeartPainter extends CustomPainter {
  _WingHeartPainter({
    required this.color,
    required this.showGlow,
  });

  final Color color;
  final bool showGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (showGlow) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.outer, size.width * 0.02);
      // رسم الوهج الخارجي أولاً
      _drawShape(canvas, size, paint);
      paint.maskFilter = null;
    }

    // الرسم الأساسي
    _drawShape(canvas, size, paint);

    // إضافة لمعان داخلي
    final sheenPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01;
    _drawShape(canvas, size, sheenPaint);
  }

  void _drawShape(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;

    // رسم القلب المركزي بلمسة فنية (حلقة لانهائية)
    final heartPath = Path();
    heartPath.moveTo(w * 0.5, h * 0.75);
    heartPath.cubicTo(
      w * 0.2,
      h * 0.5,
      w * 0.2,
      h * 0.2,
      w * 0.5,
      h * 0.35,
    );
    heartPath.cubicTo(
      w * 0.8,
      h * 0.2,
      w * 0.8,
      h * 0.5,
      w * 0.5,
      h * 0.75,
    );

    // رسم الجناح المدمج مع القلب
    final wingPath = Path();
    wingPath.moveTo(w * 0.35, h * 0.45);
    // ريش الجناح - الجزء العلوي
    wingPath.quadraticBezierTo(w * 0.1, h * 0.2, w * 0.05, h * 0.5);
    wingPath.quadraticBezierTo(w * 0.15, h * 0.45, w * 0.25, h * 0.5);

    // ريش الجناح - الجزء الأوسط
    wingPath.moveTo(w * 0.3, h * 0.55);
    wingPath.quadraticBezierTo(w * 0.05, h * 0.4, w * 0.1, h * 0.7);
    wingPath.quadraticBezierTo(w * 0.2, h * 0.6, w * 0.3, h * 0.65);

    // الريشة السفلية
    wingPath.moveTo(w * 0.35, h * 0.65);
    wingPath.quadraticBezierTo(w * 0.15, h * 0.8, w * 0.3, h * 0.85);

    canvas.drawPath(heartPath, paint);
    canvas.drawPath(wingPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// خلفية الإتقان المعرفي - Cognitive Procedural Background
/// خلفية ذكية تعتمد على التدرجات الرياضية والجسيمات لتحقيق أداء مثالي.
class CognitiveBackground extends StatelessWidget {
  /// Creates a [CognitiveBackground] with emotional color theming.
  const CognitiveBackground({
    super.key,
    required this.emotionalColor,
    this.particleCount = 25,
  });

  /// The base color representing the current emotional state.
  final Color emotionalColor;

  /// The number of floating particles to render.
  final int particleCount;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              emotionalColor.withValues(alpha: 0.2),
              emotionalColor.withValues(alpha: 0.05),
              Colors.black,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: particleCount > 0
            ? _CognitiveParticles(count: particleCount)
            : const SizedBox.expand(),
      );
}

class _CognitiveParticles extends StatefulWidget {
  const _CognitiveParticles({required this.count});
  final int count;

  @override
  State<_CognitiveParticles> createState() => _CognitiveParticlesState();
}

class _CognitiveParticlesState extends State<_CognitiveParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: _CognitiveParticlePainter(_controller.value, widget.count),
          child: const SizedBox.expand(),
        ),
      );
}

class _CognitiveParticlePainter extends CustomPainter {
  _CognitiveParticlePainter(this.progress, this.count);
  final double progress;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Seed for consistency
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final double xBase = random.nextDouble();
      final double yBase = random.nextDouble();
      final double radius = random.nextDouble() * 2 + 0.5;
      final double speed = random.nextDouble() * 0.1 + 0.02;

      final double x =
          (xBase * size.width + math.sin(progress * math.pi * 2 + i) * 20) %
              size.width;
      final double y =
          (yBase * size.height - progress * size.height * speed) % size.height;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
