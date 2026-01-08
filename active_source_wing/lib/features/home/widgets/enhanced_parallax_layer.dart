import 'package:flutter/material.dart';
import 'dart:math' as math;

/// طبقة المنظور المحسنة - Enhanced Parallax Layer
/// تقدم تأثيرات بصرية متقدمة مع حركة ثلاثية الأبعاد
/// Parallax layer component with enhanced visual effects.
class EnhancedParallaxLayer extends StatefulWidget {
  /// Creates an [EnhancedParallaxLayer].
  const EnhancedParallaxLayer({
    super.key,
    required this.child,
    this.parallaxFactor = 0.5,
    this.overlayColor,
    this.opacity = 1.0,
    this.enableRotation = false,
    this.enableScale = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Factor to control the parallax effect intensity.
  final double parallaxFactor;

  /// Optional color to overlay on the child.
  final Color? overlayColor;

  /// Opacity of the layer.
  final double opacity;

  /// Whether to enable rotation animation.
  final bool enableRotation;

  /// Whether to enable scale animation.
  final bool enableScale;

  /// Duration of animations.
  final Duration animationDuration;

  @override
  State<EnhancedParallaxLayer> createState() => _EnhancedParallaxLayerState();
}

class _EnhancedParallaxLayerState extends State<EnhancedParallaxLayer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    // تهيئة محركات الحركة
    // Initialize animation controllers
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // تهيئة الحركات
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // بدء الحركات
    // Start animations
    _animationController.forward();
    _scaleController.forward();

    if (widget.enableRotation) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _updateScrollOffset(double offset) {
    setState(() {
      _scrollOffset = offset * widget.parallaxFactor;
    });
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            _updateScrollOffset(notification.metrics.pixels);
          }
          return false;
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _fadeAnimation,
            _rotationAnimation,
            _scaleAnimation,
          ]),
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _scrollOffset),
            child: Transform.scale(
              scale: widget.enableScale ? _scaleAnimation.value : 1.0,
              child: Transform.rotate(
                angle: widget.enableRotation ? _rotationAnimation.value : 0.0,
                child: Opacity(
                  opacity: _fadeAnimation.value * widget.opacity,
                  child: Container(
                    decoration: widget.overlayColor != null
                        ? BoxDecoration(
                            color: widget.overlayColor!.withValues(alpha: 0.1),
                          )
                        : null,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// مكون الخلفية المتحركة - Animated Background Component
/// Animated background component with gradient and particles.
class AnimatedBackgroundComponent extends StatefulWidget {
  /// Creates an [AnimatedBackgroundComponent].
  const AnimatedBackgroundComponent({
    super.key,
    this.gradientColors = const [
      Color(0xFFFF6B9D),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
    ],
    this.animationDuration = const Duration(seconds: 10),
    this.enableParticles = true,
  });

  /// Colors used in the background gradient.
  final List<Color> gradientColors;

  /// Duration of the background animation.
  final Duration animationDuration;

  /// Whether to show floating particles.
  final bool enableParticles;

  @override
  State<AnimatedBackgroundComponent> createState() =>
      _AnimatedBackgroundComponentState();
}

class _AnimatedBackgroundComponentState
    extends State<AnimatedBackgroundComponent> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  widget.gradientColors[0],
                  widget.gradientColors[1],
                  _gradientAnimation.value,
                )!,
                Color.lerp(
                  widget.gradientColors[1],
                  widget.gradientColors[2],
                  _gradientAnimation.value,
                )!,
              ],
            ),
          ),
          child: widget.enableParticles
              ? CustomPaint(
                  painter: ParticlesPainter(_gradientAnimation.value),
                  child: Container(),
                )
              : Container(),
        ),
      );
}

/// رسام الجسيمات - Particles Painter
/// Painter for rendering floating particles.
class ParticlesPainter extends CustomPainter {
  /// Creates a [ParticlesPainter].
  ParticlesPainter(this.animationValue) : particles = _generateParticles();

  /// Current animation value to drive particle movement.
  final double animationValue;

  /// List of particles to paint.
  final List<Particle> particles;

  static List<Particle> _generateParticles() {
    final random = math.Random();
    return List.generate(
        20,
        (index) => Particle(
              x: random.nextDouble(),
              y: random.nextDouble(),
              size: random.nextDouble() * 4 + 1,
              speed: random.nextDouble() * 0.02 + 0.01,
              opacity: random.nextDouble() * 0.5 + 0.2,
            ));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x =
          (particle.x + animationValue * particle.speed) % 1.0 * size.width;
      final y = (particle.y + animationValue * particle.speed * 0.5) %
          1.0 *
          size.height;

      paint.color = Colors.white
          .withValues(alpha: particle.opacity * (1.0 - animationValue.abs()));

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// نموذج الجسيم - Particle Model
/// Model representing a single particle.
class Particle {
  /// Creates a [Particle].
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  /// X coordinate (0.0 to 1.0).
  final double x;

  /// Y coordinate (0.0 to 1.0).
  final double y;

  /// Size of the particle.
  final double size;

  /// Speed of the particle.
  final double speed;

  /// Opacity of the particle.
  final double opacity;
}

/// مكون التأثير الضوئي - Light Effect Component
/// Component that adds a glowing light effect to its child.
class LightEffectComponent extends StatefulWidget {
  /// Creates a [LightEffectComponent].
  const LightEffectComponent({
    super.key,
    required this.child,
    this.lightColor = Colors.white,
    this.intensity = 0.3,
  });

  /// The widget to apply the effect to.
  final Widget child;

  /// Color of the light effect.
  final Color lightColor;

  /// Intensity of the light effect.
  final double intensity;

  @override
  State<LightEffectComponent> createState() => _LightEffectComponentState();
}

class _LightEffectComponentState extends State<LightEffectComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.lightColor.withValues(
                  alpha: widget.intensity * _animation.value,
                ),
                blurRadius: 20 * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
          child: widget.child,
        ),
      );
}
