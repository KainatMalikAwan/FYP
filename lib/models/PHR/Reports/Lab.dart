
class Lab {
  final int id;
  final String name;

  Lab({required this.id, required this.name});

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id'],
      name: json['name'],
    );
  }
}