import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  static const _categoryIcons = {
    'Home Workout': Icons.home_outlined,
    'Gym Workout': Icons.fitness_center,
    'Weight Loss': Icons.local_fire_department_outlined,
    'Weight Gain': Icons.trending_up,
    'Strength': Icons.sports_handball_outlined,
    'HIIT': Icons.bolt_outlined,
    'Yoga': Icons.self_improvement,
    'Stretching': Icons.accessibility_new,
    'Senior Fitness': Icons.elderly_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Categories')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SafetyDisclaimerBanner(
              message: AppConstants.medicalDisclaimer,
            ),
            const SizedBox(height: 20),
            Text('Choose a category',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.workoutCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final category = AppConstants.workoutCategories[index];
                return AppCard(
                  onTap: () => context.push('/workouts/$category'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        _categoryIcons[category] ?? Icons.sports_gymnastics,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        category,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Recovery & Pain Relief',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.recoveryCategories
                  .map(
                    (c) => ActionChip(
                      label: Text(c),
                      onPressed: () => context.push('/workouts/$c'),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
