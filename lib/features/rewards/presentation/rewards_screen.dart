import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jdonuts/core/constants/app_colors.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/challenge_artwork.dart';

import '../../home/application/home_providers.dart';
import '../../welcome/data/models/challenge_model.dart';
import '../application/rewards_providers.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _badgeController;
  late final AnimationController _earnController;

  String selectedTab = 'earn';

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _earnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _entryController.forward();
      _badgeController.forward();
      _earnController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _badgeController.dispose();
    _earnController.dispose();
    super.dispose();
  }

  void selectTab(String value) {
    if (selectedTab == value) return;

    setState(() => selectedTab = value);
  }

  @override
  Widget build(BuildContext context) {
    final memberAsync = ref.watch(memberProvider);
    final challengesAsync = ref.watch(rewardsChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: memberAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Unable to load member: $error'),
                ),
                data: (member) {
                  if (member == null) {
                    return const Center(
                      child: Text('Member information not found'),
                    );
                  }

                  return challengesAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Unable to load challenges: $error'),
                    ),
                    data: (challenges) {
                      final filteredChallenges = challenges
                          .where((item) => item.tab == selectedTab)
                          .toList();

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildPointsAndTier(member),
                            _buildTabs(),
                            _buildChallengeList(filteredChallenges),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 22, 16, 18),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "J’ Donuts Rewards",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _badgeController,
              curve: Curves.elasticOut,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(0),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Rewards',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 21,
                    height: 21,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsAndTier(dynamic member) {
    final points = (member.points as num).toInt();
    final tier = member.tier.toString();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildTierItem(
                  title: 'Silver',
                  subtitle: tier == 'Silver' ? 'You’re here now' : 'Completed',
                  symbol: 'S',
                  color: const Color(0xFFBDBDBD),
                  active: tier == 'Silver',
                  delay: 0,
                ),
                _buildTierItem(
                  title: 'Gold',
                  subtitle: '${member.pointsToNext} pts Remaining\nto become Gold',
                  symbol: 'G',
                  color: const Color(0xFFFFD85C),
                  active: tier == 'Gold',
                  delay: 1,
                ),
                _buildTierItem(
                  title: 'Platinum',
                  subtitle: 'You’ll be here soon',
                  symbol: 'P',
                  color: const Color(0xFF66D9EF),
                  active: tier == 'Platinum',
                  delay: 2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 245,
              child: AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  final progress = Curves.easeOutCubic.transform(
                    _entryController.value,
                  );

                  return CustomPaint(
                    painter: PointsRingPainter(progress: progress),
                    child: Center(
                      child: Container(
                        width: 145,
                        height: 145,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total points',
                              style: TextStyle(
                                color: Color(0xFFFF4C9A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: points.toDouble(),
                              ),
                              duration: const Duration(milliseconds: 1800),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Text(
                                  NumberFormat('#,###').format(value.round()),
                                  style: const TextStyle(
                                    color: AppColors.activeColor,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierItem({
    required String title,
    required String subtitle,
    required String symbol,
    required Color color,
    required bool active,
    required int delay,
  }) {
    final start = delay * 0.2;

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        final animationValue = ((_entryController.value - start) / 0.5)
            .clamp(0.0, 1.0);

        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animationValue)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: active ? 0.35 : 0.16),
                border: Border.all(
                  color: color,
                  width: active ? 2.5 : 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                symbol,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.55),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: active ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton('earn', 'Eat more earn more', 200),
          const SizedBox(width: 8),
          _tabButton('gift', 'Gift', 80),
        ],
      ),
    );
  }

  Widget _tabButton(String value, String label, double width) {
    final selected = selectedTab == value;

    return GestureDetector(
      onTap: () => selectTab(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF55CBE5) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.white : const Color(0xFFE8EAEC),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeList(List<ChallengeModel> challenges) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: challenges.isEmpty
            ? const Padding(
          key: ValueKey('empty'),
          padding: EdgeInsets.all(40),
          child: Center(
            child: Text('No challenges available'),
          ),
        )
            : Column(
          key: ValueKey(selectedTab),
          children: [
            for (int i = 0; i < challenges.length; i++)
              _buildChallengeCard(challenges[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(ChallengeModel challenge, int index) {
    final completed = challenge.isCompleted;

    return TweenAnimationBuilder<double>(
      key: ValueKey('${selectedTab}_${challenge.id}'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + index * 180),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 145,
              height: 125,
              child: _buildChallengeArtwork(challenge),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${challenge.progress}/${challenge.target}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      _buildEarnButton(completed),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          '${challenge.points} pts',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeArtwork(ChallengeModel challenge) {
    return ChallengeArtwork(
      type: challenge.type,
      progress: challenge.progress,
      target: challenge.target,
    );
  }

  Widget _buildEarnButton(bool completed) {
    final button = GestureDetector(
      onTapDown: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: completed
              ? const Color(0xFF55CBE5)
              : const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'EARN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );

    if (!completed) return button;

    return AnimatedBuilder(
      animation: _earnController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_earnController.value * 0.055),
          child: child,
        );
      },
      child: button,
    );
  }
}

// Points Ring

class PointsRingPainter extends CustomPainter {
  final double progress;

  PointsRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.43;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final background = Paint()
      ..color = const Color(0xFFEDEFF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 42;

    final pink = Paint()
      ..color = const Color(0xFFF4519B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 42
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, background);

    canvas.drawArc(
      rect,
      -1.2,
      2 * 3.1415926535 * 0.90 * progress,
      false,
      pink,
    );

    final sprinklePaint = Paint()
      ..color = const Color(0xFFFFB6D5)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 18; i++) {
      final angle = (i * 0.35) - 1.1;
      final x = center.dx + (radius * 0.98) * _cos(angle);
      final y = center.dy + (radius * 0.98) * _sin(angle);

      canvas.drawLine(
        Offset(x - 4, y - 4),
        Offset(x + 4, y + 4),
        sprinklePaint,
      );
    }
  }

  double _cos(double value) => _Trig.cos(value);
  double _sin(double value) => _Trig.sin(value);

  @override
  bool shouldRepaint(covariant PointsRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Donut Progress

class DonutProgressPainter extends CustomPainter {
  final double progress;

  DonutProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 43.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final background = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 19;

    final pink = Paint()
      ..color = const Color(0xFFFF75B6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 19;

    canvas.drawCircle(center, radius, background);

    final sweep = 2 * 3.1415926535 * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      rect,
      -3.1415926535 / 2,
      sweep,
      false,
      pink,
    );

    final sprinkle = Paint()
      ..color = const Color(0xFFFFC94F)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = i * 0.52;
      final x = center.dx + radius * _Trig.cos(angle);
      final y = center.dy + radius * _Trig.sin(angle);

      canvas.drawCircle(Offset(x, y), 1.7, sprinkle);
    }

    final hole = Paint()..color = Colors.white;
    canvas.drawCircle(center, 24, hole);
  }

  @override
  bool shouldRepaint(covariant DonutProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Coffee Progress

class CoffeeProgressPainter extends CustomPainter {
  final double progress;

  CoffeeProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      12,
      12,
      size.width - 24,
      size.height - 15,
    );

    final background = Paint()
      ..color = const Color(0xFFECEFF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final orange = Paint()
      ..color = const Color(0xFFFF801C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      3.1415926535,
      3.1415926535,
      false,
      background,
    );

    canvas.drawArc(
      rect,
      3.1415926535,
      3.1415926535 * progress.clamp(0.0, 1.0),
      false,
      orange,
    );
  }

  @override
  bool shouldRepaint(covariant CoffeeProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Trig {
  static double cos(double value) => math.cos(value);
  static double sin(double value) => math.sin(value);
}