import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Profile',
      theme: ThemeData(
        primaryColor: Color(0xFF199A8E),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF199A8E)),
      ),
      home: PatientProfileScreen(),
    );
  }
}

class PatientProfileScreen extends StatefulWidget {
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late SharedPreferences _prefs;
  late String _fullName;
  late String _dob;

  late String _email;
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = _prefs.getString('fullName') ?? '';
      _dob = _prefs.getString('dob') ?? '';

      _email = _prefs.getString('email') ?? '';
      _phoneNumber = _prefs.getString('phoneNumber') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CustomTextBox(
                label: 'Full Name',
                icon: Icons.person,
                initialValue: _fullName,
              ),
              SizedBox(height: 10),
              CustomTextBox(
                label: 'Date of Birth',
                icon: Icons.calendar_today,
                initialValue: _dob,
              ),

              SizedBox(height: 20),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CustomTextBox(
                label: 'Email Address',
                icon: Icons.email,
                initialValue: _email,
              ),
              SizedBox(height: 10),
              CustomTextBox(
                label: 'Phone Number',
                icon: Icons.phone,
                initialValue: _phoneNumber,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save changes
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final String initialValue;
  final Function(String)? onChanged;

  const CustomTextBox({
    required this.label,
    required this.icon,
    required this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: initialValue,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
