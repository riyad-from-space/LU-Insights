import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/club_model.dart';
import '../repositories/clubs_repository.dart';

final clubsRepositoryProvider = Provider((ref) => ClubsRepository());

final clubsListProvider = FutureProvider<List<ClubModel>>((ref) async {
  final repo = ref.watch(clubsRepositoryProvider);
  return repo.fetchClubs();
});
