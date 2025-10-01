class TransportationMember {
  final String id;
  final String name;
  final String designation;
  final String contact;

  TransportationMember({
    required this.id,
    required this.name,
    required this.designation,
    required this.contact,
  });

  factory TransportationMember.fromMap(Map<String, dynamic> map, String id) {
    return TransportationMember(
      id: id,
      name: map['name'] ?? '',
      designation: map['designation'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'designation': designation,
      'contact': contact,
    };
  }
}
