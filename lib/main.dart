import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insights/features/admin/admin_seed_screen.dart';
import 'package:insights/features/auth/view/screen/login_screen.dart';
import 'package:insights/features/auth/view/screen/profile_screen.dart';
import 'package:insights/features/auth/view/screen/signup_screen.dart';
import 'package:insights/features/home/view/about_university_screen.dart';
import 'package:insights/features/home/view/classrooms_screen.dart';
import 'package:insights/features/home/view/clubs_screen.dart';
import 'package:insights/features/home/view/exam_materials_screen.dart';
import 'package:insights/features/home/view/home_screen.dart';
import 'package:insights/features/home/view/student_live_track_screen.dart';

import 'features/admin/admin_panel_screen.dart';
import 'features/auth/view_model/auth_viewmodel.dart';
import 'features/transportation/view/transportation_screen.dart';
import 'firebase_options.dart';

class _AdminRouteGuard extends StatelessWidget {
  final Widget child;
  const _AdminRouteGuard(this.child);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authStatus = ref.watch(authStatusProvider);
        return authStatus.when(
          data: (user) {
            if (user != null && user.email == 'admin_lu@gmail.com') {
              return child;
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Access Denied'),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                body: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Access Denied',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Only administrators can access this section.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            body: Center(child: Text('Error: ${e.toString()}')),
          ),
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final authStatus = ref.watch(authStatusProvider);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/about': (context) => const AboutUniversityScreen(),
              '/classrooms': (context) => const ClassroomsScreen(),
              '/exam_materials': (context) => const ExamMaterialsScreen(),
              '/bus_schedules': (context) => const TransportationScreen(),
              '/clubs': (context) => const ClubsScreen(),
              '/student_live_track': (context) =>
                  const StudentLiveTrackScreen(),
              '/admin_seed': (context) =>
                  const _AdminRouteGuard(AdminSeedScreen()),
              '/profile': (context) => const ProfileScreen(),
              '/transportation': (context) => const TransportationScreen(),
            },
            home: authStatus.when(
              data: (user) {
                if (user != null && user.email == 'admin_lu@gmail.com') {
                  return const AdminPanelScreen();
                } else if (user != null) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              },
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())),
              error: (e, _) =>
                  Scaffold(body: Center(child: Text('Error: ${e.toString()}'))),
            ),
          );
        },
      ),
    );
  }
}
