import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/transportation_member_model.dart';
import '../model/transportation_post_model.dart';
import '../model/transportation_schedule_model.dart';

class TransportationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TransportationMember>> getMembers() {
    return _firestore.collection('transportation_members').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TransportationMember.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<TransportationSchedule>> getSchedules() {
    return _firestore.collection('transportation_schedules').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final routes = (data['routes'] as List)
                .map((r) => RouteBus(
                      routeNumber: r['routeNumber'],
                      busNumbers: List<String>.from(r['busNumbers']),
                    ))
                .toList();
            return TransportationSchedule(
              id: doc.id,
              direction: data['direction'],
              time: data['time'],
              routes: routes,
            );
          }).toList(),
        );
  }

  Stream<List<TransportationPost>> getPosts() {
    return _firestore
        .collection('transportation_posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransportationPost.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addPost(TransportationPost post) async {
    await _firestore.collection('transportation_posts').add(post.toMap());
  }

  Future<void> updatePost(TransportationPost post) async {
    await _firestore
        .collection('transportation_posts')
        .doc(post.id)
        .update(post.toMap());
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('transportation_posts').doc(postId).delete();
  }
}
