# LU Insights

A Flutter + Firebase campus companion app for students of Leading University, Sylhet, with bus schedules, transport notices and a clubs directory, all in one place.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-2.x-0553B1)

<!-- Screenshots: add 3–4 phone screenshots here, e.g. <img src="screenshots/home.png" width="220"> -->

## Features

- **Email/password accounts.** Students sign up with their name, username and student ID. Sign-up sends a verification email and stores the profile in Firestore. There's also a profile screen with logout.
- **Start screen based on auth state.** Signed-out users see the login screen, students see the home screen and the admin account goes to the admin panel.
- **Home menu loaded from Firestore.** The home menu is built from a `features` collection, so you can add, remove or reorder entries without shipping a new build. Pull down to refresh it.
- **Transportation hub** with three tabs that update live from Firestore:
  - **Bus Schedule**: trips to and from the university by time, with route numbers and bus numbers.
  - **Members**: the transport committee's names, designations and contact details.
  - **Posts**: transport notices, newest first.
- **Managing transport notices (admin only).** The admin account can create, edit and delete posts after entering an extra transportation passcode.
- **Clubs directory**: a read-only list of university clubs from Firestore.
- **Admin panel (admin only)**: a dashboard with shortcuts to Transportation and Clubs. Non-admins who open admin routes get an "Access Denied" screen.

Not implemented yet: the screens for Live Tracking, Exam Materials, Classrooms and About University are only placeholders, and so are the admin panel's Class Rep, Guardian and Analytics tiles. There's no GPS or location tracking in the app yet.

## Architecture

Each feature follows an MVVM layout:

- **model**: plain Dart classes with `fromMap` / `toMap` for Firestore documents.
- **repositories**: the only layer that talks to Firebase (`FirebaseAuth`, `FirebaseFirestore`).
- **view_model**: Riverpod providers that sit between screens and repositories. A plain `Provider` exposes each repository. Data is read through `FutureProvider` for one-off reads (home features, clubs) or `StreamProvider` for real-time Firestore snapshots (transportation). Auth actions go through a `StateNotifierProvider` (`AuthController`), and a `StreamProvider` over `authStateChanges()` drives navigation.
- **view**: `ConsumerWidget` screens that `watch` providers and render loading, error and data states with `AsyncValue.when`.

Admin access currently depends on one admin email set in `lib/main.dart`. Each user profile already stores a `role` field, and there's an `AppRole` enum, but neither is used for access control yet.

```
lib/
└── features/
    ├── admin/                # admin dashboard + admin account setup screen
    ├── auth/
    │   ├── model/            # UserModel, AppRole enum
    │   ├── repositories/     # Firebase Auth + `users` collection
    │   ├── view/screen/      # login, sign-up, profile (+ shared components/)
    │   └── view_model/       # AuthController, auth-state stream, AuthState
    ├── clubs/
    │   ├── model/            # ClubModel
    │   ├── repositories/     # reads the `clubs` collection
    │   └── view_model/       # clubs FutureProvider (screen lives in home/view)
    ├── home/
    │   ├── model/            # FeatureModel (one home-menu entry)
    │   ├── repositories/     # reads the `features` collection
    │   ├── view/             # home screen + feature screens
    │   └── view_model/       # features FutureProvider
    └── transportation/
        ├── model/            # schedule, member and post models
        ├── repositories/     # Firestore streams + post create/update/delete
        ├── view/             # tabbed Transportation screen
        └── view_model/       # StreamProviders for schedules, members, posts
```

## Tech stack

- **Flutter** (Material 3) for the UI
- **flutter_riverpod** for state management and dependency injection
- **firebase_core** to initialise Firebase with the generated `firebase_options.dart`
- **firebase_auth** for email/password sign-up, sign-in and verification emails
- **cloud_firestore** for user profiles, the home menu, clubs and transportation data (real-time streams)
- **flutter_lints** for static analysis

## Getting started

### Prerequisites

- Flutter 3.24 or newer (the pubspec requires Dart SDK `^3.5.4`)
- A Firebase project of your own
- The [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup): `dart pub global activate flutterfire_cli`

### 1. Clone and install

```bash
git clone https://github.com/riyad-from-space/LU-Insights.git
cd LU-Insights
flutter pub get
```

### 2. Connect your Firebase project

```bash
flutterfire configure
```

This command regenerates `lib/firebase_options.dart`, `firebase.json` and the platform config files so they point at your project. In the Firebase console:

- Turn on **Authentication → Email/Password**.
- Create a **Cloud Firestore** database. The repo doesn't include security rules, so write your own before you deploy.

### 3. Add data

There's no seeding script yet, so add documents in the Firebase console. These are the collections the app reads:

| Collection | Fields |
|---|---|
| `features` | `id`, `title`, `description`, `icon` (`school`, `class`, `menu_book`, `directions_bus`, `groups`, `location_on`), `route` (`/transportation`, `/clubs`, `/about`, `/classrooms`, `/exam_materials`, `/student_live_track`) |
| `clubs` | `id`, `name`, `description`, `icon` (`computer`, `sports`, `music`, `social`, `debate`, `tourism`) |
| `transportation_schedules` | `direction` (`to` / `from`), `time` (e.g. `8:00 AM`), `routes`: array of `{ routeNumber: number, busNumbers: [string] }` |
| `transportation_members` | `name`, `designation`, `contact` |
| `transportation_posts` | `title`, `content`, `authorId`, `createdAt` (timestamp). Admins can manage these in the app. |

The app writes `users` documents itself when someone signs up.

To use the admin features, change the admin email in `lib/main.dart` and `lib/features/transportation/view/transportation_screen.dart` to your own, then sign up in the app with that email. The transportation passcode is also defined in `transportation_screen.dart`.

### 4. Run

```bash
flutter run
```

## Author

Riyad Ahmed Sagor · [Portfolio](https://riyad-portfolio-f18db.web.app) · [LinkedIn](https://www.linkedin.com/in/riyadfromspace/)
