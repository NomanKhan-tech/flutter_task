import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

// Data models
class TrainingWorkout {
  final String tag;
  final Color tagColor;
  final Color tagTextColor;
  final String title;
  final String duration;
  final IconData icon;

  const TrainingWorkout({
    required this.tag,
    required this.tagColor,
    required this.tagTextColor,
    required this.title,
    required this.duration,
    required this.icon,
  });
}

class TrainingDay {
  final String dayName;
  final int dayNumber;
  final bool isActive;
  final TrainingWorkout? workout;

  const TrainingDay({
    required this.dayName,
    required this.dayNumber,
    this.isActive = false,
    this.workout,
  });
}

// Week section widget
class TrainingWeekSection extends StatelessWidget {
  final String weekLabel;
  final String dateRange;
  final int totalMin;
  final List<TrainingDay> days;
  final bool isCollapsed;

  const TrainingWeekSection({
    super.key,
    required this.weekLabel,
    required this.dateRange,
    required this.totalMin,
    required this.days,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week header
        Container(
          color: AppColors.backgroundSection,

          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekLabel,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Total: ${totalMin}min',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Day rows
        if (!isCollapsed)
          ...days.map((day) => _DayRow(day: day)),
        // Bottom colored accent line
        if (isCollapsed)
          Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accentTeal, AppColors.accentBlue],
              ),
            ),
          ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final TrainingDay day;

  const _DayRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Day label + number
              SizedBox(
                width: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.dayName,
                      style: TextStyle(
                        color: day.isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${day.dayNumber}',
                      style: TextStyle(
                        color: day.isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontSize: 22,
                        fontWeight:
                            day.isActive ? FontWeight.w700 : FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Workout card or empty
              if (day.workout != null)
                Expanded(child: _WorkoutRow(workout: day.workout!))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
        const Divider(
          color: AppColors.divider,
          height: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  final TrainingWorkout workout;

  const _WorkoutRow({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
          border:const Border(left:BorderSide(color:Colors.white,width:10))
      ),
      child: Row(
        children: [
          // Drag handle dots
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.5),
                child: Row(
                  children: List.generate(2, (j) {
                    return Container(
                      width: 3,
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,

                      ),
                    );
                  }),
                ),
              );
            }),
          ),
          const SizedBox(width: 10),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: workout.tagColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        workout.icon,
                        color: workout.tagTextColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        workout.tag,
                        style: TextStyle(
                          color: workout.tagTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      workout.duration,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
