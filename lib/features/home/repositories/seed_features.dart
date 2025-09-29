import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/feature_model.dart';

Future<void> seedFeatures() async {
  final features = [
    FeatureModel(
      id: 'about',
      title: 'About University',
      icon: 'school',
      route: '/about',
      description: 'Learn more about our university.',
    ),
    FeatureModel(
      id: 'classrooms',
      title: 'Classrooms',
      icon: 'class',
      route: '/classrooms',
      description: 'Find your classroom and schedules.',
    ),
    FeatureModel(
      id: 'exam_materials',
      title: 'Exam Materials',
      icon: 'menu_book',
      route: '/exam_materials',
      description: 'Access exam materials and resources.',
    ),
    FeatureModel(
      id: 'bus_schedules',
      title: 'Bus Schedules',
      icon: 'directions_bus',
      route: '/bus_schedules',
      description: 'Check university bus schedules.',
    ),
    FeatureModel(
      id: 'clubs',
      title: 'Clubs',
      icon: 'groups',
      route: '/clubs',
      description: 'Explore university clubs and activities.',
    ),
    FeatureModel(
      id: 'student_live_track',
      title: 'Student Live Track',
      icon: 'location_on',
      route: '/student_live_track',
      description: 'Track student activities live.',
    ),
  ];

  final featuresCollection = FirebaseFirestore.instance.collection('features');
  for (final feature in features) {
    await featuresCollection.doc(feature.id).set(feature.toMap());
  }
}
