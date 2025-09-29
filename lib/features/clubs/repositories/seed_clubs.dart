import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/club_model.dart';

Future<void> seedClubs() async {
  final clubs = [
    ClubModel(
      id: 'computer',
      name: 'Computer Club',
      description: 'For tech enthusiasts, coding, and innovation.',
      icon: 'computer',
    ),
    ClubModel(
      id: 'sports',
      name: 'Sports Club',
      description: 'All about sports, games, and fitness.',
      icon: 'sports',
    ),
    ClubModel(
      id: 'music',
      name: 'Music Club',
      description: 'For music lovers and performers.',
      icon: 'music',
    ),
    ClubModel(
      id: 'social',
      name: 'Social Club',
      description: 'Community, volunteering, and social work.',
      icon: 'social',
    ),
    ClubModel(
      id: 'debate',
      name: 'Debate Club',
      description: 'Debate, public speaking, and critical thinking.',
      icon: 'debate',
    ),
    ClubModel(
      id: 'tourism',
      name: 'Tourism Club',
      description: 'Travel, adventure, and exploring new places.',
      icon: 'tourism',
    ),
  ];

  final clubsCollection = FirebaseFirestore.instance.collection('clubs');
  for (final club in clubs) {
    await clubsCollection.doc(club.id).set(club.toMap());
  }
}
