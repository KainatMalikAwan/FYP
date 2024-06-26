import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../Services/config.dart';
import '../../../ThemeSettings/ThemeSettings.dart';

class AddProfileScreen extends StatefulWidget {
  final int userId;

  AddProfileScreen({required this.userId});

  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mrIdController;
  late TextEditingController _relationController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mrIdController = TextEditingController();
    _relationController = TextEditingController();
    _genderController = TextEditingController();
    _dobController = TextEditingController();
  }

  Future<void> _addProfile() async {
    final url = Uri.parse('${Config.baseUrl}/patients/profile');
    final request = http.MultipartRequest('POST', url)
      ..fields['userId'] = widget.userId.toString()
      ..fields['name'] = _nameController.text
      ..fields['mrId'] = _mrIdController.text
      ..fields['relation'] = _relationController.text
      ..fields['gender'] = _genderController.text
      ..fields['dob'] = _dobController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profileImg',
        _image!.path,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Profile added successfully');
        Navigator.pop(context);
      } else {
        print('Failed to add profile: ${response.statusCode}');
        final respStr = await response.stream.bytesToString();
        print('Response body: $respStr');
      }
    } catch (e) {
      print('Error adding profile: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileField('Name', _nameController, Icons.person),
              SizedBox(height: 10),
              _buildProfileField('MR ID', _mrIdController, Icons.badge),
              SizedBox(height: 10),
              _buildProfileField('Relation', _relationController, Icons.family_restroom),
              SizedBox(height: 10),
              _buildGenderRadio(),
              SizedBox(height: 10),
              _buildDatePicker(),
              SizedBox(height: 10),
              _buildImagePicker(),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addProfile();
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

  Widget _buildProfileField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: ThemeSettings.labelColor,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: ThemeSettings.labelColor),
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

  Widget _buildGenderRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            color: ThemeSettings.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: _genderController.text,
              onChanged: (value) {
                setState(() {
                  _genderController.text = value.toString();
                });
              },
            ),
            Text('Male'),
            Radio(
              value: 'Female',
              groupValue: _genderController.text,
              onChanged: (value) {
                setState(() {
                  _genderController.text = value.toString();
                });
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            color: ThemeSettings.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ThemeSettings.labelColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ThemeSettings.buttonColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Image',
          style: TextStyle(
            color: ThemeSettings.labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            _showImagePicker(context);
          },
          child: Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _image != null
                ? Image.file(
              _image!,
              fit: BoxFit.cover,
            )
                : Center(
              child: Icon(Icons.camera_alt, size: 40.0),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
