
import 'package:flutter/material.dart';
import 'package:fyp/screens/PHR/AllProfiles/addProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Services/API/PHR/Profile.dart';
import 'AllProfiles/allProfiles.dart';

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
  String _fullName = ''; // Initialize with an empty string
  String _gender = '';   // Initialize with an empty string
  String _email = '';    // Initialize with an empty string
  String _cnic = '';     // Initialize with an empty string
  int _uid = 0;          // Initialize with a default value (0 or null)
  int _mainUserId=0;
  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = _prefs.getString('fullName') ?? '';
      _gender = _prefs.getString('gender') ?? '';
      _email = _prefs.getString('email') ?? '';
      _cnic = _prefs.getString('cnic') ?? '';
      _uid = _prefs.getInt('userId') ?? 0;
     _mainUserId= _prefs.getInt('mainId')??0;// Ensure to handle null or default value
    });
  }

  Future<void> _saveChanges() async {

    String patientId =_mainUserId.toString(); // Replace with actual patient ID

    Map<String, dynamic> patientData = {
      'name': _fullName,
      'gender': _gender,
      'email': _email,
      'cnic': _cnic,
    };
    try {
      final response = await editPatient(patientId, patientData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes. Please try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  void _viewProfiles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilesScreen( userId:_uid)),
    );
  }
  void _addProfiles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProfileScreen(userId:_uid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _viewProfiles,
          ),
          SizedBox(width: 20,),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProfiles,
          ),
        ],
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
                onChanged: (value) {
                  setState(() {
                    _fullName = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextBox(
                label: 'Gender',
                icon: Icons.person_outline,
                initialValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextBox(
                label: 'CNIC',
                icon: Icons.credit_card,
                initialValue: _cnic,
                onChanged: (value) {
                  setState(() {
                    _cnic = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
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
    TextEditingController controller = TextEditingController(text: initialValue);

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
            labelText: label, // Use the label as hint text or modify as needed
          ),
          controller: controller,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

