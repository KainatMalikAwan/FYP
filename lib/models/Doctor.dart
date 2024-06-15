class Doctor {
  final String phone;
  final String email;
  final String gender;
  final DateTime dob;
  final String cnic;
  final String name;
  final String specialization;
  final String password;
  final int mrId;

  Doctor({
    required this.phone,
    required this.email,
    required this.gender,
    required this.dob,
    required this.cnic,
    required this.name,
    required this.specialization,
    required this.password,
    required this.mrId,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      cnic: json['cnic'],
      name: json['name'],
      specialization: json['specialization'],
      password: json['password'],
      mrId: json['mrId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'email': email,
    'gender': gender,
    'dob': dob.toIso8601String(),
    'cnic': cnic,
    'name': name,
    'specialization': specialization,
    'password': password,
    'mrId': mrId,
  };
}
