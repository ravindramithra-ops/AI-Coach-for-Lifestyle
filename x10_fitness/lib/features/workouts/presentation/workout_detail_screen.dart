import 'package:flutter/material.dart';

import '../../../core/widgets/app_widgets.dart';
import '../data/exercise_repository.dart';
import '../domain/exercise_model.dart';

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final _repository = ExerciseRepository();
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _repository.fetchByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: SafeArea(
        child: FutureBuilder<List<Exercise>>(
          future: _exercisesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final exercises = snapshot.data ?? [];
            if (exercises.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      'No exercises in "${widget.categoryName}" yet. '
                      'New content is added regularly.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: exercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return AppCard(
                  onTap: () => _showExerciseSheet(context, exercise),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.15),
                        child: Text(
                          '${exercise.caloriesPerMinute.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(
                              '${exercise.difficulty} • ${exercise.muscleGroup}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showExerciseSheet(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Text(exercise.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(exercise.description,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            SafetyDisclaimerBanner(message: exercise.safetyNotes),
            const SizedBox(height: 20),
            _SheetSection(title: 'Instructions', items: exercise.instructions),
            _SheetSection(
                title: 'Common Mistakes', items: exercise.commonMistakes),
            _SheetSection(title: 'Tips', items: exercise.tips),
          ],
        ),
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
