import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:   BoxDecoration(
        color: AppColors.backgroundPrimary,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                icon: _NutritionIcon(),
                label: 'Nutrition',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: _PlanIcon(isActive: currentIndex == 1),
                label: 'Plan',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: _MoodIcon(),
                label: 'Mood',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: const Icon(Icons.person_outline, size: 24),
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: isActive ? AppColors.navActive : AppColors.navInactive,
                size: 24,
              ),
              child: icon,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.navActive : AppColors.navInactive,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom icon widgets to match Figma designs

class _NutritionIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.eco_outlined, size: 24);
  }
}

class _PlanIcon extends StatelessWidget {
  final bool isActive;
  const _PlanIcon({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.calendar_view_week_outlined, size: 24);
  }
}

class _MoodIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.sentiment_satisfied_outlined, size: 24);
  }
}
