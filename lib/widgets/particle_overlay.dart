import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

class ParticleOverlay extends StatefulWidget {
  final int particleCount;
  const ParticleOverlay({super.key, this.particleCount = 25});

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (_) => _createParticle());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  _Particle _createParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 4 + 2,
      speed: _random.nextDouble() * 0.08 + 0.02,
      opacity: _random.nextDouble() * 0.4 + 0.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      final currentY = ((p.y - (animationValue * p.speed * 10)) % 1.0) * size.height;
      final currentX = (p.x + sin(animationValue * 2 * pi + p.y * 10) * 0.02) * size.width;

      paint.color = DuchessTheme.goldDim.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(currentX, currentY), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
