import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/week_strip.dart';
import 'widgets/workout_card.dart';
import 'widgets/insights_section.dart';
import 'widgets/calendar_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDayIndex = 1; // Tuesday (index 1 in M-Su)

  void _showCalendar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CalendarBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _TopBar(onCalendarTap: _showCalendar),
                    const SizedBox(height: 16),
                    const Text(
                      'Today, 22 Dec 2024',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    WeekStrip(
                      selectedIndex: _selectedDayIndex,
                      onDaySelected: (i) =>
                          setState(() => _selectedDayIndex = i),
                    ),
                    const SizedBox(height: 8),
                    // Week progress indicator line
                    Center(
                      child: Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Workouts',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '9°',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const WorkoutCard(
                      date: 'December 22 · 25m – 30m',
                      title: 'Upper Body',
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'My Insights',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const InsightsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onCalendarTap;

  const _TopBar({required this.onCalendarTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Bell icon
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.backgroundCard,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width:100,),
        // Week indicator
        GestureDetector(
          onTap: onCalendarTap,
          child: const Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: AppColors.textSecondary,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Week 1/4',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
