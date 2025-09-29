import 'package:flutter/material.dart';
import 'package:insights/features/clubs/repositories/seed_clubs.dart';
import 'package:insights/features/home/repositories/seed_features.dart';

class AdminSeedScreen extends StatelessWidget {
  const AdminSeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Seed Firestore Data'),
          backgroundColor: Colors.deepPurple),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await seedFeatures();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Features seeded!')));
              },
              child: const Text('Seed Home Features'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await seedClubs();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clubs seeded!')));
              },
              child: const Text('Seed Clubs'),
            ),
          ],
        ),
      ),
    );
  }
}
