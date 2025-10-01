import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/transportation_repository.dart';
import '../model/transportation_member_model.dart';
import '../model/transportation_schedule_model.dart';
import '../model/transportation_post_model.dart';

final transportationRepositoryProvider =
    Provider((ref) => TransportationRepository());

final transportationMembersProvider =
    StreamProvider<List<TransportationMember>>((ref) {
  return ref.read(transportationRepositoryProvider).getMembers();
});

final transportationSchedulesProvider =
    StreamProvider<List<TransportationSchedule>>((ref) {
  return ref.read(transportationRepositoryProvider).getSchedules();
});

final transportationPostsProvider =
    StreamProvider<List<TransportationPost>>((ref) {
  return ref.read(transportationRepositoryProvider).getPosts();
});
