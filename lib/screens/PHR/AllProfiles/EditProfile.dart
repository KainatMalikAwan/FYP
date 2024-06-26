import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Services/config.dart';
import '../../../ThemeSettings/ThemeSettings.dart';
import 'allProfiles.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile profile;

  EditProfileScreen({required this.profile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationController;
  late String _selectedGender;
  late DateTime _selectedDate;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _relationController = TextEditingController(text: widget.profile.relation);
    _selectedGender = widget.profile.gender;
    _selectedDate = widget.profile.dob;
  }

  Future<void> _editProfile() async {
    final url = Uri.parse('${Config.baseUrl}/patients/profile/edit');
    final request = http.MultipartRequest('POST', url)
      ..fields['patientId'] = widget.profile.id.toString()
      ..fields['name'] = _nameController.text
      ..fields['relation'] = _relationController.text
      ..fields['gender'] = _selectedGender
      ..fields['dob'] = DateFormat('yyyy-MM-dd').format(_selectedDate);

    if (_profileImagePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profileImg',
        _profileImagePath!,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        Navigator.pop(context);
      } else {
        print('Failed to update profile: ${response.statusCode}');
        final respStr = await response.stream.bytesToString();
        print('Response body: $respStr');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileField('Name', Icons.person, _nameController),
              SizedBox(height: 10),
              _buildProfileField('Relation', Icons.people, _relationController),
              SizedBox(height: 10),
              _buildGenderSelection(),
              SizedBox(height: 10),
              _buildDatePicker(context),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _editProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ThemeSettings.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ThemeSettings.buttonTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: ThemeSettings.labelColor,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          icon,
          color: ThemeSettings.labelColor.withOpacity(0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeSettings.labelColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeSettings.buttonColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Gender',
            style: TextStyle(
              color: ThemeSettings.labelColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              activeColor: ThemeSettings.buttonColor,
            ),
            Text('Male'),
            Radio<String>(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              activeColor: ThemeSettings.buttonColor,
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Date of Birth',
            style: TextStyle(
              color: ThemeSettings.labelColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(fontSize: 16.0),
                ),
                Icon(Icons.calendar_today, color: ThemeSettings.buttonColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
