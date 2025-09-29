import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insights/features/auth/view_model/auth_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(authControllerProvider).user;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: userModel == null && firebaseUser != null
          ? FutureBuilder(
              future: ref
                  .read(authControllerProvider.notifier)
                  .authRepository
                  .getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user logged in'));
                }
                final user = snapshot.data!;
                return _ProfileDetails(user: user, ref: ref);
              },
            )
          : userModel != null
              ? _ProfileDetails(user: userModel, ref: ref)
              : const Center(child: Text('No user logged in')),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;
  const _ProfileDetails({required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.deepPurple.withOpacity(0.2),
            child: const Icon(Icons.person, size: 56, color: Colors.deepPurple),
          ),
          const SizedBox(height: 24),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(user.email, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
