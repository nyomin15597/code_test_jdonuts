import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/core/constants/app_colors.dart';
import '../../auth/application/auth_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Check for existing user session on screen load
    Future.microtask(() async {
      final loggedIn =
      await ref.read(authControllerProvider.notifier).restoreSession();
      if (mounted && loggedIn) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top section containing decorative background circles and central donut image
          Expanded(
            flex: 4,
            child: OverflowBox(
              maxWidth: screenWidth * 1.3,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Top-left decorative background circle
                  Positioned(
                    top: -40, left: -50,
                    child: _buildCircle(200, const Color(0xFF38DBE5)),
                  ),
                  // Mid-left decorative background circle
                  Positioned(
                    top: 180, left: -40,
                    child: _buildCircle(160, const Color(0xFFC792FF)),
                  ),
                  // Top-right decorative background circle
                  Positioned(
                    top: -30, right: -10,
                    child: _buildCircle(140, const Color(0xFFFF94B9)),
                  ),
                  // Mid-right decorative background circle
                  Positioned(
                    top: 150, right: -10,
                    child: _buildCircle(130, const Color(0xFFB1B1FF)),
                  ),
                  // Centered lower background circle
                  Positioned(
                    top: 330,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _buildCircle(160, const Color(0xFFFF8A24)),
                    ),
                  ),
                  // Central Donut Image Container
                  Positioned(
                    top: 50,
                    child: Container(
                      width: 250, height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFD1DC).withValues(alpha: 0.6),
                      ),
                      child: Center(
                        child: Container(
                          width: 190, height: 190,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/coconut_donut.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Smooth bottom gradient overlay for smooth visual transition
                  Positioned(
                    bottom: 0, left: 0, right: 0, height: 90,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.4, 0.8, 1.0],
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.4),
                            const Color(0xFFFFFAFA).withValues(alpha: 0.85),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom section containing text, action buttons, and terms
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Title / Tagline
                  const Text(
                    'Round food for\nevery mood',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F), height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Get Started Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: const Color(0xFF4EE2EC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => context.go('/phone'),
                    child: const Text(
                      "LET'S GET STARTED",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login redirection prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      GestureDetector(
                        onTap: () => context.go('/phone'),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFFFF4B8B),
                            fontWeight: FontWeight.bold, fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Social login options row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(Icons.g_mobiledata, Colors.red),
                      const SizedBox(width: 28),
                      _buildSocialIcon(Icons.apple, Colors.black),
                      const SizedBox(width: 28),
                      _buildSocialIcon(Icons.facebook, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Terms and Privacy Policy acknowledgment text
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 11, color: Colors.grey, height: 1.4,
                        ),
                        children: [
                          TextSpan(text: 'By continuing, you acknowledge that you have read and\nagree to our '),
                          TextSpan(text: 'Terms of Use',
                              style: TextStyle(
                                color: Color(0xFFFF4B8B),
                                fontWeight: FontWeight.w500,
                              )),
                          TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFFFF4B8B),
                                fontWeight: FontWeight.w500,
                              )),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build decorative background circles
  Widget _buildCircle(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle, color: color.withValues(alpha: 0.35),
    ),
    child: Center(
      child: Container(
        width: size * 0.75, height: size * 0.75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
    ),
  );

  // Helper widget to build social login icon buttons
  Widget _buildSocialIcon(IconData icon, Color color) => InkWell(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle, color: Colors.white,
      ),
      child: Icon(icon, color: color, size: 20),
    ),
  );
}