# FemFit

A women's fitness and wellness tracking app built with Flutter. Users can log their workouts, track daily water intake, and do a quick mood check-in — all in one place. Data is saved locally on the device so it persists between sessions.

This is a personal project I built to practice Flutter and to create something I'd actually want to use.

## Features

- Home screen with a daily summary of all three trackers
- Workout logger with quick-add suggestions and the ability to delete entries
- Water intake tracker with a progress bar and a goal of 8 glasses a day
- Mood check-in with six mood options
- Daily data reset at midnight so you start fresh each day
- Local storage using shared_preferences — no backend needed

## Screens

- Home — daily overview with navigation to each tracker
- Workout Logger — add, view and delete today's workouts
- Water Intake — tap + or - to update your glass count
- Mood Check-in — tap a mood to log how you're feeling

## Tech stack

- Flutter 3.x
- Dart
- shared_preferences (local storage)
- intl (date formatting)

## Project structure

```
femfit/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── workout_screen.dart
│   │   ├── water_screen.dart
│   │   └── mood_screen.dart
│   └── utils/
│       └── storage_service.dart
└── pubspec.yaml
```

## How to run

Make sure you have Flutter installed, then:

```bash
git clone https://github.com/Kare100/femfit.git
cd femfit
flutter pub get
flutter run
```

You can run it on an Android emulator, iOS simulator, or a physical device.

## What I want to add next

- weekly history so you can look back at past days
- step counter using the device's pedometer
- push notifications as reminders to drink water
- a period tracker section
