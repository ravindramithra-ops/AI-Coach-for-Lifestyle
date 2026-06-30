import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/data/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final user = authRepo.currentUser;

    final dashboardItems = <_DashboardItem>[
      _DashboardItem(
        title: 'Workouts',
        subtitle: 'Browse categories & start training',
        icon: Icons.sports_gymnastics,
        route: AppRoutes.workoutCategories,
      ),
      _DashboardItem(
        title: 'BMI & Calculators',
        subtitle: 'BMI, calories, water & protein',
        icon: Icons.calculate_outlined,
        route: AppRoutes.bmiCalculator,
      ),
      _DashboardItem(
        title: 'AI Coach',
        subtitle: 'Ask fitness questions, get a plan',
        icon: Icons.smart_toy_outlined,
        route: AppRoutes.aiCoach,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('X10 Fitness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await authRepo.signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Hi, ${user?.displayName ?? 'Athlete'} 👋',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's crush today's goals.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ...dashboardItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  onTap: () => context.push(item.route),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.12),
                        child: Icon(item.icon,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(item.subtitle,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  const _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
}
