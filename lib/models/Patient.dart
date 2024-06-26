class Patient {
  String name;
  String email;
  String gender;
  String cnic;
  String password;
  DateTime dob;
  int mrId;


  // Constructor
  Patient({
    required this.name,
    required this.email,
    required this.gender,
    required this.cnic,
    required this.password,
    required this.dob,
    required this.mrId,
  });

  // Factory constructor to create a Patient object from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      cnic: json['cnic'],
      password: json['password'],
      dob: DateTime.parse(json['dob']),
      mrId: json['mrId'],
    );
  }

  // Method to convert a Patient object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'cnic': cnic,
      'password': password,
      'dob': dob.toIso8601String(),
      'mrId': mrId,
    };
  }
}
