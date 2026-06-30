import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

/// Singleton repository provider — swap implementation here for testing.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Stream of Firebase auth state (null = signed out).
final authStateProvider = StreamProvider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Tracks in-flight auth operations (login/signup) for loading UI.
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// Holds the latest auth error message for display in forms.
final authErrorProvider = StateProvider<String?>((ref) => null);
