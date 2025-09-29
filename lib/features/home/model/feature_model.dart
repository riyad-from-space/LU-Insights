class FeatureModel {
  final String id;
  final String title;
  final String icon;
  final String route;
  final String description;

  FeatureModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'route': route,
      'description': description,
    };
  }

  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    return FeatureModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      icon: map['icon'] ?? '',
      route: map['route'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
