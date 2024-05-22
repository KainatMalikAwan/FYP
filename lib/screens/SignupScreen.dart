import 'package:flutter/material.dart';
import 'package:fyp/CustomWidgets/CustomTextBox.dart';
import 'package:fyp/CustomWidgets/CustomButton.dart';
import 'package:fyp/screens/PHR/Home.dart';// Import the CustomButton widget

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _selectedOption = 'Patient Signup';
  String _gender = '';

  Widget _buildForm() {
    switch (_selectedOption) {
      case 'Patient Signup':
        return _buildPatientSignupForm();
      case 'Doctor Signup':
        return _buildDoctorSignupForm();
      case 'Lab Signup':
        return _buildLabSignupForm();
      default:
        return Container();
    }
  }

  Widget _buildPatientSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextBox(
          label: 'Full Name',
          icon: Icons.person,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Email',
          icon: Icons.email,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Date of Birth',
          icon: Icons.date_range,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'CNIC',
          icon: Icons.credit_card,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Phone Number',
          icon: Icons.phone,
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Text('Gender: '),
            Radio(
              value: 'Male',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
            ),
            Text('Male'),
            Radio(
              value: 'Female',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextBox(
          label: 'Full Name',
          icon: Icons.person,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Email',
          icon: Icons.email,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Date of Birth',
          icon: Icons.date_range,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'CNIC',
          icon: Icons.credit_card,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Phone Number',
          icon: Icons.phone,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Specialization',
          icon: Icons.assignment_ind,
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Text('Gender: '),
            Radio(
              value: 'Male',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
            ),
            Text('Male'),
            Radio(
              value: 'Female',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value.toString();
                });
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildLabSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextBox(
          label: 'Lab Name',
          icon: Icons.business,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Address',
          icon: Icons.location_on,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Email',
          icon: Icons.email,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <String>[
                  'Patient Signup',
                  'Doctor Signup',
                  'Lab Signup',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              _buildForm(),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Sign Up',
                onPressed: () {
    if (_selectedOption == 'Patient Signup') {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
    ); }
                },
                color: Color(0xFF199A8E), // Set background color similar to splash screen
              ),
            ],
          ),
        ),
      ),
    );
  }
}
