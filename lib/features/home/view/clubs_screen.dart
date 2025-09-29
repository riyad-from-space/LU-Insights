import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../clubs/view_model/clubs_viewmodel.dart';

class ClubsScreen extends ConsumerWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(clubsListProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Clubs'), backgroundColor: Colors.deepPurple),
      body: clubsAsync.when(
        data: (clubs) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: clubs.length,
          separatorBuilder: (context, i) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final club = clubs[i];
            return Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              shadowColor: Colors.deepPurple.withOpacity(0.15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.withOpacity(0.10),
                      Colors.deepPurple.withOpacity(0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(_iconFromString(club.icon),
                        color: Colors.deepPurple, size: 28),
                  ),
                  title: Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                      letterSpacing: 0.2,
                    ),
                  ),
                  subtitle: Text(club.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.arrow_forward_ios,
                        color: Colors.deepPurple, size: 18),
                  ),
                  onTap: () {
                    // TODO: Show club details
                  },
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'computer':
        return Icons.computer;
      case 'sports':
        return Icons.sports_soccer;
      case 'music':
        return Icons.music_note;
      case 'social':
        return Icons.people;
      case 'debate':
        return Icons.record_voice_over;
      case 'tourism':
        return Icons.card_travel;
      default:
        return Icons.groups;
    }
  }
}
