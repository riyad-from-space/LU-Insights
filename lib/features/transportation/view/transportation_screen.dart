import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/view_model/auth_viewmodel.dart';
import '../model/transportation_post_model.dart';
import '../view_model/transportation_viewmodel.dart';

class TransportationScreen extends ConsumerStatefulWidget {
  const TransportationScreen({super.key});

  @override
  ConsumerState<TransportationScreen> createState() =>
      _TransportationScreenState();
}

class _TransportationScreenState extends ConsumerState<TransportationScreen> {
  bool isTransportAdmin = false;
  bool passwordChecked = false;

  void _checkAdminPassword() async {
    final passwordController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Transportation Admin Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context, passwordController.text == 'transportation_12345');
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
    if (result == true) {
      setState(() {
        isTransportAdmin = true;
        passwordChecked = true;
      });
    } else if (result == false) {
      setState(() {
        isTransportAdmin = false;
        passwordChecked = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect password.')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.watch(authControllerProvider).user;
    if (user != null && user.email == 'admin_lu@gmail.com') {
      if (!isTransportAdmin) {
        _checkAdminPassword();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final isAdmin =
        user != null && user.email == 'admin_lu@gmail.com' && isTransportAdmin;
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
        body: TabBarView(
          children: [
            _BusScheduleTab(isAdmin: isAdmin),
            const _MembersTab(),
            _PostsTab(isAdmin: isAdmin),
          ],
        ),
        floatingActionButton: isAdmin
            ? Builder(
                builder: (context) {
                  final tabIndex = DefaultTabController.of(context).index;
                  if (tabIndex == 2) {
                    // Posts tab
                    return FloatingActionButton(
                      onPressed: () =>
                          _showAddPostDialog(context, ref, user.uid),
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.add),
                    );
                  } else if (tabIndex == 0) {
                    // Bus Schedule tab
                    return FloatingActionButton(
                      onPressed: () => _showEditScheduleDialog(context, ref),
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.edit),
                    );
                  }
                  return Container();
                },
              )
            : null,
      ),
    );
  }

  void _showAddPostDialog(
      BuildContext context, WidgetRef ref, String authorId) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content')),
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

  void _showEditScheduleDialog(BuildContext context, WidgetRef ref) {
    // For demo: just show a message. Implement full schedule editing as needed.
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Edit Schedule'),
        content: Text('Schedule editing UI goes here.'),
      ),
    );
  }
}

class _BusScheduleTab extends ConsumerWidget {
  final bool isAdmin;
  const _BusScheduleTab({required this.isAdmin});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(transportationSchedulesProvider);
    return schedulesAsync.when(
      data: (schedules) => ListView(
        children: schedules
            .map((s) => Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                        '${s.direction == 'to' ? 'To University' : 'From University'} - ${s.time}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: s.routes
                          .map((r) => Text(
                              'Route ${r.routeNumber}: ${r.busNumbers.join(', ')}'))
                          .toList(),
                    ),
                  ),
                ))
            .toList(),
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
        children: members
            .map((m) => Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(m.name),
                    subtitle: Text(m.designation),
                    trailing: Text(m.contact),
                  ),
                ))
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _PostsTab extends ConsumerWidget {
  final bool isAdmin;
  const _PostsTab({required this.isAdmin});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(transportationPostsProvider);
    return postsAsync.when(
      data: (posts) => ListView(
        children: posts
            .map((p) => Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(p.title),
                    subtitle: Text(p.content),
                    trailing: Text(
                        '${p.createdAt.hour}:${p.createdAt.minute.toString().padLeft(2, '0')}'),
                  ),
                ))
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
