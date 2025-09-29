import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/feature_model.dart';

class HomeRepository {
  final _featuresCollection = FirebaseFirestore.instance.collection('features');

  Future<List<FeatureModel>> fetchFeatures() async {
    final snapshot = await _featuresCollection.get();
    return snapshot.docs
        .map((doc) => FeatureModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addFeature(FeatureModel feature) async {
    await _featuresCollection.add(feature.toMap());
  }
}
