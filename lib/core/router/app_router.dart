import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/features/settings/settings_screen.dart';

import '../../features/auth/presentation/screens/dob_screen.dart';
import '../../features/auth/presentation/screens/name_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/phone_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/product/presentation/product_detail_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

import '../../shared/widgets/bottom_navigation.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Authentication
    GoRoute(
      path: '/phone',
      builder: (context, state) => const PhoneScreen(),
    ),

    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),

    GoRoute(
      path: '/name',
      builder: (context, state) => const NameScreen(),
    ),

    GoRoute(
      path: '/dob',
      builder: (context, state) => const DobScreen(),
    ),

    // Welcome
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        int selectedIndex = 0;
        final path = state.uri.path;

        if (path.startsWith('/home')) {
          selectedIndex = 0;
        } else if (path.startsWith('/rewards')) {
          selectedIndex = 1;
        } else if (path.startsWith('/explore')) {
          selectedIndex = 2;
        } else if (path.startsWith('/scan')) {
          selectedIndex = 3;
        } else if (path.startsWith('/settings')) {
          selectedIndex = 4;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: AppBottomNavigation(selectedIndex: selectedIndex),
        );
      },
      routes: [
        // Home
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Rewards
        GoRoute(
          path: '/rewards',
          builder: (context, state) => const RewardsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);

        return ProductDetailScreen(
          productId: id,
        );
      },
    ),
  ],
);