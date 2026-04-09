import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/training_week_section.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Training Calendar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Teal/blue separator line
            Container(
              height: 2,
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentBlue, AppColors.accentTeal],
                ),
              ),
            ),
            // Scrollable content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  TrainingWeekSection(
                    weekLabel: 'Week 2/8',
                    dateRange: 'December 8-14',
                    totalMin: 60,
                    days: [
                      TrainingDay(
                        dayName: 'Mon',
                        dayNumber: 8,
                        isActive: true,
                        workout: TrainingWorkout(
                          tag: 'Arms Workout',
                          tagColor: AppColors.tagArms,
                          tagTextColor: AppColors.tagArmsText,
                          title: 'Arm Blaster',
                          duration: '25m - 30m',
                          icon: Icons.fitness_center,
                        ),
                      ),
                      TrainingDay(dayName: 'Tue', dayNumber: 9),
                      TrainingDay(dayName: 'Wed', dayNumber: 10),
                      TrainingDay(
                        dayName: 'Thu',
                        dayNumber: 11,
                        isActive: true,
                        workout: TrainingWorkout(
                          tag: 'Leg Workout',
                          tagColor: AppColors.tagLegs,
                          tagTextColor: AppColors.tagLegsText,
                          title: 'Leg Day Blitz',
                          duration: '25m - 30m',
                          icon: Icons.directions_run,
                        ),
                      ),
                      TrainingDay(dayName: 'Fri', dayNumber: 12),
                      TrainingDay(dayName: 'Sat', dayNumber: 13),
                      TrainingDay(dayName: 'Sun', dayNumber: 14),
                    ],
                  ),
                  TrainingWeekSection(
                    weekLabel: 'Week 2',
                    dateRange: 'December 14-22',
                    totalMin: 60,
                    days: [],
                    isCollapsed: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
