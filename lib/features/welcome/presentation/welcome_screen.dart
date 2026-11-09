import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/core/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
                        children: [
                          _buildDonutCard(
                            imagePath: 'assets/images/donuts/01.jpg',
                            height: 250,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDonutCard(
                            imagePath: 'assets/images/donuts/02.jpg',
                            height: 250,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Right Column
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 60), // Masonry stagger offset
                          _buildDonutCard(
                            imagePath: 'assets/images/donuts/03.jpg',
                            height: 250,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(36),
                              bottomLeft: Radius.circular(36),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDonutCard(
                            imagePath: 'assets/images/donuts/04.jpg',
                            height: 250,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(36),
                              bottomLeft: Radius.circular(36),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.7, 1.0],
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    const Color(0xFFFFEBF2).withValues(alpha: 0.3),
                    const Color(0xFFFFEBF2).withValues(alpha: 0.7),
                    const Color(0xFFFFEBF2),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(28, 25, 28, 45),
              child: Column(
                children: [
                  // Welcome Title Text
                  const Text(
                    "Welcome to the\nworld of J'donuts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // LET'S EXPLORE Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () => context.go('/home'),
                      child: const Text(
                        "LET'S EXPLORE",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
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

  // Helper widget to build individual donut card images
  Widget _buildDonutCard({
    required String imagePath,
    required double height,
    required BorderRadius borderRadius,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.donut_large, size: 50, color: Colors.pinkAccent),
              ),
            );
          },
        ),
      ),
    );
  }
}