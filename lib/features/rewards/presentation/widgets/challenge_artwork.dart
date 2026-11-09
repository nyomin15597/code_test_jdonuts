import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChallengeArtwork extends StatefulWidget {
  final String type;
  final int progress;
  final int target;

  const ChallengeArtwork({
    super.key,
    required this.type,
    required this.progress,
    required this.target,
  });

  @override
  State<ChallengeArtwork> createState() => _ChallengeArtworkState();
}

class _ChallengeArtworkState extends State<ChallengeArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    controller.forward();
  }

  @override
  void didUpdateWidget(covariant ChallengeArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress ||
        oldWidget.target != widget.target ||
        oldWidget.type != widget.type) {
      controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.target <= 0
        ? 0.0
        : (widget.progress / widget.target).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: widget.type == 'donut'
              ? DonutArtworkPainter(
            progress: value * animation.value,
          )
              : CoffeeArtworkPainter(
            progress: value * animation.value,
          ),
          child: SizedBox(
            width: 145,
            height: 125,
            child: Center(
              child: widget.type == 'donut'
                  ? const Icon(
                Icons.donut_large,
                size: 35,
                color: Color(0xFFFF75B6),
              )
                  : const Icon(
                Icons.local_cafe,
                size: 52,
                color: Color(0xFF9B633F),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DonutArtworkPainter extends CustomPainter {
  final double progress;

  DonutArtworkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 43.0;
    const strokeWidth = 20.0;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final backgroundPaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final pinkPaint = Paint()
      ..color = const Color(0xFFFF75B6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Full grey donut.
    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    // Fill progress in quarters.
    final completedQuarters = (progress * 4).clamp(0.0, 4.0);
    final fullQuarters = completedQuarters.floor();
    final partialQuarter = completedQuarters - fullQuarters;

    for (int i = 0; i < fullQuarters; i++) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + (i * math.pi / 2),
        math.pi / 2,
        false,
        pinkPaint,
      );
    }

    if (partialQuarter > 0 && fullQuarters < 4) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + (fullQuarters * math.pi / 2),
        (math.pi / 2) * partialQuarter,
        false,
        pinkPaint,
      );
    }

    // Donut hole.
    canvas.drawCircle(
      center,
      25,
      Paint()..color = Colors.white,
    );

    // Small sprinkles.
    final sprinklePaint = Paint()
      ..color = const Color(0xFFFFD45C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        1.7,
        sprinklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DonutArtworkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class CoffeeArtworkPainter extends CustomPainter {
  final double progress;

  CoffeeArtworkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      15,
      12,
      size.width - 30,
      size.height - 20,
    );

    final backgroundPaint = Paint()
      ..color = const Color(0xFFECEFF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFFFF801C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    // Background arc.
    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Progress arc.
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CoffeeArtworkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}