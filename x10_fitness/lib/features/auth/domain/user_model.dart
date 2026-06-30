import 'package:equatable/equatable.dart';

/// Domain model representing an authenticated app user / Firestore profile.
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessGoal,
    this.fitnessLevel,
    this.healthConditions = const [],
  });

  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? fitnessGoal;
  final String? fitnessLevel;
  final List<String> healthConditions;

  double? get bmi {
    if (heightCm == null || weightKg == null || heightCm == 0) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] as String? ?? '',
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      heightCm: (map['heightCm'] as num?)?.toDouble(),
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      fitnessGoal: map['fitnessGoal'] as String?,
      fitnessLevel: map['fitnessLevel'] as String?,
      healthConditions:
          (map['healthConditions'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'fitnessGoal': fitnessGoal,
      'fitnessLevel': fitnessLevel,
      'healthConditions': healthConditions,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? fitnessGoal,
    String? fitnessLevel,
    List<String>? healthConditions,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        photoUrl,
        age,
        gender,
        heightCm,
        weightKg,
        fitnessGoal,
        fitnessLevel,
        healthConditions,
      ];
}
