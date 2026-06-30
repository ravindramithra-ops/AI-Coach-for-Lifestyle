import 'package:equatable/equatable.dart';

/// Represents a single exercise within a workout category.
class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.equipment,
    required this.muscleGroup,
    required this.caloriesPerMinute,
    required this.durationMinutes,
    required this.description,
    required this.instructions,
    required this.commonMistakes,
    required this.tips,
    required this.safetyNotes,
    this.videoUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String name;
  final String category;
  final String difficulty;
  final String equipment;
  final String muscleGroup;
  final double caloriesPerMinute;
  final int durationMinutes;
  final String description;
  final List<String> instructions;
  final List<String> commonMistakes;
  final List<String> tips;
  final String safetyNotes;
  final String? videoUrl;
  final String? thumbnailUrl;

  @override
  List<Object?> get props => [id, name, category, difficulty];
}
