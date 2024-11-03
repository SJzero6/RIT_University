class Nationality {
  final int id;
  final String name;

  Nationality({
    required this.id,
    required this.name,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      id: json['id'],
      name: json['name'],
    );
  }
}
