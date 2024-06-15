class Vitals {
  final int id;
  final String name;

  Vitals({
    required this.id,
    required this.name,
  });

  factory Vitals.fromJson(Map<String, dynamic> json) {
    return Vitals(
      id: json['id'],
      name: json['name'],
    );
  }
}




