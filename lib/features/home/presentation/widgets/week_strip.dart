import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WeekStrip extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const WeekStrip({
    super.key,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  static const List<String> _dayLabels = ['M', 'TU', 'W', 'TH', 'F', 'SA', 'SU'];
  static const List<int> _dayNumbers = [21, 22, 23, 24, 25, 26, 27];

  // Activity dot colors per day (null = no activity)
  static   List<Color?> _dotColors = [
    null,
    AppColors.accentTeal,   // Tuesday - active
    AppColors.textMuted,    // Wednesday
    AppColors.accentBlue,   // Thursday
    AppColors.accentPurple.withOpacity(0.7), // Friday - pinkish
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = index == selectedIndex;
        final dotColor = _dotColors[index];

        return GestureDetector(
          onTap: () => onDaySelected(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Text(
                _dayLabels[index],
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.backgroundCard
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: AppColors.accentTeal,
                          width: 1.5,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${_dayNumbers[index]}',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Activity dot
              SizedBox(
                height: 6,
                child: dotColor != null
                    ? Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
