import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresAsync = ref.watch(featuresListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: featuresAsync.when(
          data: (features) => ListView.separated(
            itemCount: features.length,
            separatorBuilder: (context, i) => const SizedBox(height: 18),
            itemBuilder: (context, i) {
              final feature = features[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, feature.route),
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.deepPurple.withOpacity(0.18),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.withOpacity(0.09),
                          Colors.deepPurple.withOpacity(0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(_iconFromString(feature.icon),
                            color: Colors.deepPurple, size: 32),
                      ),
                      title: Text(
                        feature.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: Text(feature.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.arrow_forward_ios,
                            color: Colors.deepPurple, size: 20),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
        ),
      ),
    );
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'class':
        return Icons.class_;
      case 'menu_book':
        return Icons.menu_book;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'groups':
        return Icons.groups;
      case 'location_on':
        return Icons.location_on;
      default:
        return Icons.star;
    }
  }
}
