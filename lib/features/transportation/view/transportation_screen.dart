import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/transportation_viewmodel.dart';
import '../../auth/view_model/auth_viewmodel.dart';
import '../../auth/model/app_role.dart';
import '../model/transportation_post_model.dart';

class TransportationScreen extends ConsumerWidget {
  const TransportationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final isTransportAdmin = user?.role == appRoleToString(AppRole.transportationAdmin);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transportation'),
          backgroundColor: Colors.deepPurple,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bus Schedule'),
              Tab(text: 'Members'),
              Tab(text: 'Posts'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BusScheduleTab(),
            _MembersTab(),
            _PostsTab(),
          ],
        ),
        floatingActionButton: isTransportAdmin
            ? FloatingActionButton(
                onPressed: () => _showAddPostDialog(context, ref, user!.uid),
                child: const Icon(Icons.add),
                backgroundColor: Colors.deepPurple,
              )
            : null,
      ),
    );
  }

  static void _showAddPostDialog(BuildContext context, WidgetRef ref, String authorId) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final post = TransportationPost(
                id: '',
                title: titleController.text,
                content: contentController.text,
                authorId: authorId,
                createdAt: DateTime.now(),
              );
              await ref.read(transportationRepositoryProvider).addPost(post);
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class _BusScheduleTab extends ConsumerWidget {
  const _BusScheduleTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(transportationSchedulesProvider);
    return schedulesAsync.when(
      data: (schedules) => ListView(
        children: schedules.map((s) => Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('${s.direction == 'to' ? 'To University' : 'From University'} - ${s.time}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: s.routes.map((r) => Text('Route ${r.routeNumber}: ${r.busNumbers.join(', ')}')).toList(),
            ),
          ),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _MembersTab extends ConsumerWidget {
  const _MembersTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(transportationMembersProvider);
    return membersAsync.when(
      data: (members) => ListView(
        children: members.map((m) => Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(m.name),
            subtitle: Text(m.designation),
            trailing: Text(m.contact),
          ),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _PostsTab extends ConsumerWidget {
  const _PostsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(transportationPostsProvider);
    return postsAsync.when(
      data: (posts) => ListView(
        children: posts.map((p) => Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(p.title),
            subtitle: Text(p.content),
            trailing: Text('${p.createdAt.hour}:${p.createdAt.minute.toString().padLeft(2, '0')}'),
          ),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
