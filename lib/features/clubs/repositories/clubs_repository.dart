import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/club_model.dart';

class ClubsRepository {
  final _clubsCollection = FirebaseFirestore.instance.collection('clubs');

  Future<List<ClubModel>> fetchClubs() async {
    final snapshot = await _clubsCollection.get();
    return snapshot.docs.map((doc) => ClubModel.fromMap(doc.data())).toList();
  }

  Future<void> addClub(ClubModel club) async {
    await _clubsCollection.add(club.toMap());
  }
}
