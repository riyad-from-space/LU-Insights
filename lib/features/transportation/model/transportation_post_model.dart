class TransportationPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final DateTime createdAt;

  TransportationPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });

  factory TransportationPost.fromMap(Map<String, dynamic> map, String id) {
    return TransportationPost(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      authorId: map['authorId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'createdAt': createdAt,
    };
  }
}
