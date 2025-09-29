import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/feature_model.dart';
import '../repositories/home_repository.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository());

final featuresListProvider = FutureProvider<List<FeatureModel>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.fetchFeatures();
});
