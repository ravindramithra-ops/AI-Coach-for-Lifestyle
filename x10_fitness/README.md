# X10 AI Fitness Coach

India's home fitness & recovery Android app. Flutter + Riverpod + Firebase, Clean Architecture, Material 3.

## What's included in this build

This is a **working foundation**, not the full feature checklist from the original spec (that would be tens of thousands of lines across hundreds of files — not deliverable in one pass). It includes real, functioning code for:

- Project skeleton: Clean Architecture (`core/` + feature-first `lib/features/`), Riverpod DI, go_router navigation, Material 3 light/dark theme
- Authentication: Email/password sign up & login, Google Sign-In, OTP phone auth, forgot password — all wired to Firebase Auth + Firestore user profiles
- Home dashboard
- Workout categories (9 categories + 8 recovery categories from the spec) with a seeded exercise dataset (instructions, mistakes, tips, safety notes) and exercise detail bottom sheet
- BMI / water / calorie calculators
- AI Coach chat screen with a pluggable `AiCoachService` interface (currently a mock — wire to a Cloud Function backed by your LLM provider of choice)
- Medical/safety disclaimer banners on all health-related screens, per the spec's safety requirement

**Not yet built**: nutrition meal plans, progress tracking/charts, video player, push notifications, gamification, pose detection, wearables integration, localization (Hindi/Telugu), offline caching, and the full test suite. The architecture is set up so each of these slots in as a new `features/<name>` folder following the same pattern as `workouts/` or `auth/`.

## Prerequisites

- Flutter SDK (stable channel, 3.22+): https://docs.flutter.dev/get-started/install
- Android Studio or VS Code with Flutter/Dart plugins
- A Firebase project (free Spark plan is enough to start)
- Node.js (only needed if you later add Cloud Functions for the AI Coach backend)

## 1. Get the code running locally

```bash
cd x10_fitness
flutter pub get
```

## 2. Connect Firebase (required — auth/Firestore won't work without this)

1. Create a project at https://console.firebase.google.com
2. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Run from the project root:
   ```bash
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` and downloads `android/app/google-services.json` automatically.
4. In `lib/main.dart`, replace:
   ```dart
   await Firebase.initializeApp();
   ```
   with:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```
   (add `import 'firebase_options.dart';` at the top)
5. In the Firebase console, enable: **Authentication** → Email/Password, Google, Phone providers; **Firestore Database** (start in test mode for development, then lock down with proper rules before launch).

## 3. Run on a connected Android device / emulator

```bash
flutter devices        # confirm a device is detected
flutter run
```

## 4. Build a release APK

```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk` — install this directly on any Android phone.

For a smaller, Play Store-ready bundle:
```bash
flutter build appbundle --release
```

**Before a real release**, replace the debug signing config in `android/app/build.gradle` with your own keystore — see https://docs.flutter.dev/deployment/android for the signing guide.

## Project structure

```
lib/
  core/                  # theme, router, constants, validators, shared widgets
  features/
    auth/                # login, signup, OTP, forgot password
    home/                # dashboard
    workouts/             # categories, exercise data, detail screens
    calculators/          # BMI/water/calorie
    ai_coach/              # chat UI + pluggable AI backend interface
  main.dart
android/                 # native Android project (Gradle, manifest)
```

## Next steps to extend toward the full spec

Each remaining feature follows the same `data/domain/presentation` pattern already used in `workouts/`. For example, to add nutrition meal plans: create `lib/features/nutrition/{data,domain,presentation}`, a `MealPlan` model, a repository, and a screen, then register the route in `core/router/app_router.dart`.
