import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/core/constants/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.card_giftcard, 'label': 'Reward'},
      {'icon': Icons.radar_outlined, 'label': 'Explore'},
      {'icon': Icons.qr_code_scanner_outlined, 'label': 'Scan'},
      {'icon': Icons.settings_outlined, 'label': 'Settings'},
    ];

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final slotWidth = totalWidth / navItems.length;

            const double activeWidth = 82.0;

            double calculatedLeft = selectedIndex == 0
                ? 6.0
                : (slotWidth * selectedIndex) + ((slotWidth - activeWidth) / 2);

            if (calculatedLeft + activeWidth > totalWidth - 6) {
              calculatedLeft = totalWidth - activeWidth - 6;
            }

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  left: calculatedLeft,
                  top: 10,
                  bottom: 10,
                  width: activeWidth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.activeColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          navItems[selectedIndex]['icon'] as IconData,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          navItems[selectedIndex]['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  children: List.generate(
                    navItems.length,
                        (index) {
                      final isSelected = index == selectedIndex;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (index == 0) {
                              context.go('/home');
                            } else if (index == 1) {
                              context.go('/rewards');
                            } else if (index == 4) {
                              context.go('/settings');
                            }
                          },
                          child: SizedBox(
                            height: 72,
                            child: Center(
                              child: Opacity(
                                opacity: isSelected ? 0.0 : 1.0,
                                child: Icon(
                                  navItems[index]['icon'] as IconData,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}