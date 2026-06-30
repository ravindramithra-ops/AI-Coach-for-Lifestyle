import '../domain/exercise_model.dart';

/// Seed exercise dataset used until the Firestore-backed exercise
/// collection is wired in. Replace [ExerciseRepository.fetchByCategory]
/// with a Firestore query once the `exercises` collection is populated.
class ExerciseRepository {
  static final List<Exercise> _seedData = [
    const Exercise(
      id: 'pushup_standard',
      name: 'Standard Push-Up',
      category: 'Home Workout',
      difficulty: 'Beginner',
      equipment: 'None',
      muscleGroup: 'Chest, Shoulders, Triceps',
      caloriesPerMinute: 7,
      durationMinutes: 1,
      description:
          'A classic bodyweight exercise that builds upper-body and core strength.',
      instructions: [
        'Start in a plank position with hands shoulder-width apart.',
        'Lower your body until your chest nearly touches the floor.',
        'Push back up to the starting position, keeping your core tight.',
      ],
      commonMistakes: [
        'Letting the hips sag or pike up',
        'Flaring elbows out at 90 degrees',
      ],
      tips: ['Keep your neck neutral', 'Breathe out as you push up'],
      safetyNotes:
          'Avoid if you have an acute wrist or shoulder injury. Stop if you feel sharp pain.',
    ),
    const Exercise(
      id: 'bodyweight_squat',
      name: 'Bodyweight Squat',
      category: 'Home Workout',
      difficulty: 'Beginner',
      equipment: 'None',
      muscleGroup: 'Quadriceps, Glutes, Hamstrings',
      caloriesPerMinute: 8,
      durationMinutes: 1,
      description: 'Foundational lower-body movement for strength and mobility.',
      instructions: [
        'Stand with feet shoulder-width apart.',
        'Lower your hips back and down as if sitting in a chair.',
        'Drive through your heels to return to standing.',
      ],
      commonMistakes: ['Knees collapsing inward', 'Heels lifting off the ground'],
      tips: ['Keep chest up', 'Push knees out in line with toes'],
      safetyNotes:
          'Use a chair for support if you have balance or knee concerns. Consult a doctor if you have severe knee pain.',
    ),
    const Exercise(
      id: 'cat_cow_stretch',
      name: 'Cat-Cow Stretch',
      category: 'Lower Back',
      difficulty: 'Beginner',
      equipment: 'Mat',
      muscleGroup: 'Spine, Core',
      caloriesPerMinute: 2,
      durationMinutes: 2,
      description: 'A gentle flow to mobilize the spine and relieve lower back tension.',
      instructions: [
        'Start on hands and knees in a tabletop position.',
        'Inhale, drop the belly, lift chest and tailbone (cow).',
        'Exhale, round the spine, tuck chin and pelvis (cat).',
      ],
      commonMistakes: ['Moving too fast', 'Holding breath'],
      tips: ['Move slowly with your breath'],
      safetyNotes:
          'Educational guidance only. If you have a diagnosed spinal condition, consult a physiotherapist before performing this stretch.',
    ),
    const Exercise(
      id: 'neck_tilt_stretch',
      name: 'Seated Neck Tilt',
      category: 'Neck',
      difficulty: 'Beginner',
      equipment: 'Chair',
      muscleGroup: 'Neck, Upper Trapezius',
      caloriesPerMinute: 1,
      durationMinutes: 1,
      description: 'A simple desk-friendly stretch to release neck tension.',
      instructions: [
        'Sit tall and relax your shoulders.',
        'Gently tilt your head toward one shoulder until you feel a stretch.',
        'Hold for 15-20 seconds, then switch sides.',
      ],
      commonMistakes: ['Pulling the head with force', 'Raising the shoulder to meet the ear'],
      tips: ['Keep movements slow and controlled'],
      safetyNotes:
          'Stop immediately if you feel dizziness, numbness, or sharp pain, and consult a doctor.',
    ),
    const Exercise(
      id: 'surya_namaskar',
      name: 'Surya Namaskar (Sun Salutation)',
      category: 'Yoga',
      difficulty: 'Intermediate',
      equipment: 'Mat',
      muscleGroup: 'Full Body',
      caloriesPerMinute: 6,
      durationMinutes: 5,
      description: 'A traditional sequence of 12 yoga postures performed as one flow.',
      instructions: [
        'Begin standing in Pranamasana (prayer pose).',
        'Flow through the 12 postures in sequence, syncing breath with movement.',
        'Repeat for several rounds at a comfortable pace.',
      ],
      commonMistakes: ['Rushing through transitions', 'Holding breath instead of flowing with it'],
      tips: ['Practice on an empty stomach', 'Build up rounds gradually'],
      safetyNotes:
          'Avoid deep backbends or inversions if pregnant or with high blood pressure, without medical clearance.',
    ),
    const Exercise(
      id: 'hiit_jumping_jacks',
      name: 'Jumping Jacks',
      category: 'HIIT',
      difficulty: 'Beginner',
      equipment: 'None',
      muscleGroup: 'Full Body, Cardio',
      caloriesPerMinute: 10,
      durationMinutes: 1,
      description: 'High-intensity full body cardio movement to elevate heart rate quickly.',
      instructions: [
        'Stand with feet together, arms at sides.',
        'Jump feet out while raising arms overhead.',
        'Jump back to starting position and repeat.',
      ],
      commonMistakes: ['Landing flat-footed', 'Locking knees on landing'],
      tips: ['Land softly on the balls of your feet'],
      safetyNotes:
          'High-impact — modify to a low-impact step version if you have knee or joint concerns.',
    ),
  ];

  Future<List<Exercise>> fetchByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _seedData.where((e) => e.category == category).toList();
  }

  Future<List<Exercise>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _seedData;
  }

  Future<List<Exercise>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final q = query.toLowerCase();
    return _seedData
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.muscleGroup.toLowerCase().contains(q))
        .toList();
  }
}
