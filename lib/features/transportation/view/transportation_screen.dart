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
                  context, passwordController.text == 'transportationlu');
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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Incorrect password.')));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.watch(authControllerProvider).user;
    if (user != null && user.email == 'admin_lu@gmail.com') {
      if (!passwordChecked) {
        _checkAdminPassword();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final isAdmin =
        user != null && user.email == 'admin_lu@gmail.com' && isTransportAdmin;

    // Show admin password instruction if user is admin but hasn't entered transportation password
    final showAdminInstruction = user != null &&
        user.email == 'admin_lu@gmail.com' &&
        !isTransportAdmin &&
        passwordChecked;

    // Debug info - remove this later
    print(
        'Debug - User: ${user?.email}, isTransportAdmin: $isTransportAdmin, isAdmin: $isAdmin, passwordChecked: $passwordChecked');
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
        body: Column(
          children: [
            // Admin instruction banner
            if (showAdminInstruction)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.orange.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Enter transportation password to access admin features',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _checkAdminPassword,
                      child: const Text(
                        'Enter Password',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _BusScheduleTab(isAdmin: isAdmin),
                  const _MembersTab(),
                  _PostsTab(isAdmin: isAdmin),
                ],
              ),
            ),
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
                          _TransportationScreenHelper.showAddPostDialog(
                              context, ref, user.uid),
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
            const SizedBox(height: 16),
            TextField(
                controller: contentController,
                maxLines: 3,
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
              if (titleController.text.trim().isEmpty ||
                  contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in both title and content')),
                );
                return;
              }

              final post = TransportationPost(
                id: '',
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                authorId: authorId,
                createdAt: DateTime.now(),
              );
              await ref.read(transportationRepositoryProvider).addPost(post);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post added successfully!')),
                );
              }
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
    print('Debug PostsTab - isAdmin: $isAdmin');
    return postsAsync.when(
      data: (posts) {
        return Column(
          children: [
            // Debug info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.blue.withOpacity(0.1),
              child: Text(
                'Debug: isAdmin = $isAdmin',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),

            // Add Post Button for Admins
            if (isAdmin) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Get current user ID for author
                    final user = ref.read(authControllerProvider).user;
                    if (user != null) {
                      _TransportationScreenHelper.showAddPostDialog(
                          context, ref, user.uid);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
            ],

            // Always show a test button for debugging
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  final user = ref.read(authControllerProvider).user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Debug: User=${user?.email}, isAdmin=$isAdmin',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('DEBUG: Check Admin Status'),
              ),
            ),

            // Posts List or Empty State
            Expanded(
              child: posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No posts yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isAdmin
                                ? 'Create the first transportation update!'
                                : 'Be the first to share transportation updates!',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: posts
                          .map((p) => Card(
                                margin: const EdgeInsets.all(8),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    p.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        p.content,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatDateTime(p.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: isAdmin
                                      ? PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _TransportationScreenHelper
                                                  .showEditPostDialog(
                                                      context, ref, p);
                                            } else if (value == 'delete') {
                                              _TransportationScreenHelper
                                                  .showDeleteConfirmationDialog(
                                                      context, ref, p.id);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 18),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      size: 18,
                                                      color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                          child: const Icon(
                                            Icons.more_vert,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                ),
                              ))
                          .toList(),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _TransportationScreenHelper {
  static void showAddPostDialog(
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
            const SizedBox(height: 16),
            TextField(
                controller: contentController,
                maxLines: 3,
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
              if (titleController.text.trim().isEmpty ||
                  contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in both title and content')),
                );
                return;
              }

              final post = TransportationPost(
                id: '',
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                authorId: authorId,
                createdAt: DateTime.now(),
              );
              await ref.read(transportationRepositoryProvider).addPost(post);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post added successfully!')),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  static void showEditPostDialog(
      BuildContext context, WidgetRef ref, TransportationPost post) {
    final titleController = TextEditingController(text: post.title);
    final contentController = TextEditingController(text: post.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 16),
            TextField(
                controller: contentController,
                maxLines: 3,
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
              if (titleController.text.trim().isEmpty ||
                  contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in both title and content')),
                );
                return;
              }

              final updatedPost = TransportationPost(
                id: post.id,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                authorId: post.authorId,
                createdAt: post.createdAt,
              );
              await ref
                  .read(transportationRepositoryProvider)
                  .updatePost(updatedPost);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post updated successfully!')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  static void showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
            'Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(transportationRepositoryProvider)
                  .deletePost(postId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
