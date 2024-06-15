// // import 'package:flutter/material.dart';
// // import 'package:fyp/CustomWidgets/CustomTextBox.dart';
// // import 'package:fyp/CustomWidgets/CustomButton.dart';
// // import 'package:fyp/screens/PHR/Home.dart';// Import the CustomButton widget
// //
// // class SignupScreen extends StatefulWidget {
// //   @override
// //   _SignupScreenState createState() => _SignupScreenState();
// // }
// //
// // class _SignupScreenState extends State<SignupScreen> {
// //   String _selectedOption = 'Patient Signup';
// //   String _gender = '';
// //
// //   Widget _buildForm() {
// //     switch (_selectedOption) {
// //       case 'Patient Signup':
// //         return _buildPatientSignupForm();
// //       case 'Doctor Signup':
// //         return _buildDoctorSignupForm();
// //       case 'Lab Signup':
// //         return _buildLabSignupForm();
// //       default:
// //         return Container();
// //     }
// //   }
// //
// //   Widget _buildPatientSignupForm() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         CustomTextBox(
// //           label: 'Full Name',
// //           icon: Icons.person,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Email',
// //           icon: Icons.email,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Confirm Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Date of Birth',
// //           icon: Icons.date_range,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'CNIC',
// //           icon: Icons.credit_card,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Phone Number',
// //           icon: Icons.phone,
// //         ),
// //         SizedBox(height: 16.0),
// //         Row(
// //           children: [
// //             Text('Gender: '),
// //             Radio(
// //               value: 'Male',
// //               groupValue: _gender,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _gender = value.toString();
// //                 });
// //               },
// //             ),
// //             Text('Male'),
// //             Radio(
// //               value: 'Female',
// //               groupValue: _gender,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _gender = value.toString();
// //                 });
// //               },
// //             ),
// //             Text('Female'),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildDoctorSignupForm() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         CustomTextBox(
// //           label: 'Full Name',
// //           icon: Icons.person,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Email',
// //           icon: Icons.email,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Confirm Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Date of Birth',
// //           icon: Icons.date_range,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'CNIC',
// //           icon: Icons.credit_card,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Phone Number',
// //           icon: Icons.phone,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Specialization',
// //           icon: Icons.assignment_ind,
// //         ),
// //         SizedBox(height: 16.0),
// //         Row(
// //           children: [
// //             Text('Gender: '),
// //             Radio(
// //               value: 'Male',
// //               groupValue: _gender,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _gender = value.toString();
// //                 });
// //               },
// //             ),
// //             Text('Male'),
// //             Radio(
// //               value: 'Female',
// //               groupValue: _gender,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _gender = value.toString();
// //                 });
// //               },
// //             ),
// //             Text('Female'),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildLabSignupForm() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         CustomTextBox(
// //           label: 'Lab Name',
// //           icon: Icons.business,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Address',
// //           icon: Icons.location_on,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Email',
// //           icon: Icons.email,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //         SizedBox(height: 16.0),
// //         CustomTextBox(
// //           label: 'Confirm Password',
// //           icon: Icons.lock,
// //           isPassword: true,
// //         ),
// //       ],
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Signup'),
// //       ),
// //       body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
// //         child: Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               DropdownButton<String>(
// //                 value: _selectedOption,
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     _selectedOption = newValue!;
// //                   });
// //                 },
// //                 items: <String>[
// //                   'Patient Signup',
// //                   'Doctor Signup',
// //                   'Lab Signup',
// //                 ].map<DropdownMenuItem<String>>((String value) {
// //                   return DropdownMenuItem<String>(
// //                     value: value,
// //                     child: Text(value),
// //                   );
// //                 }).toList(),
// //               ),
// //               SizedBox(height: 16.0),
// //               _buildForm(),
// //               SizedBox(height: 16.0),
// //               CustomButton(
// //                 text: 'Sign Up',
// //                 onPressed: () {
// //     if (_selectedOption == 'Patient Signup') {
// //     Navigator.push(
// //     context,
// //     MaterialPageRoute(builder: (context) => HomeScreen()),
// //     ); }
// //                 },
// //                 color: Color(0xFF199A8E), // Set background color similar to splash screen
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:fyp/CustomWidgets/CustomTextBox.dart';
// import 'package:fyp/CustomWidgets/CustomButton.dart';
// import 'package:fyp/screens/PHR/Home.dart';
//
// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   String _selectedOption = 'Patient Signup';
//   String _gender = '';
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _cnicController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _specializationController = TextEditingController();
//   final TextEditingController _labNameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   Widget _buildForm() {
//     switch (_selectedOption) {
//       case 'Patient Signup':
//         return _buildPatientSignupForm();
//       case 'Doctor Signup':
//         return _buildDoctorSignupForm();
//       case 'Lab Signup':
//         return _buildLabSignupForm();
//       default:
//         return Container();
//     }
//   }
//
//   Widget _buildPatientSignupForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CustomTextBox(
//           label: 'Full Name',
//           icon: Icons.person,
//           controller: _fullNameController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Email',
//           icon: Icons.email,
//           controller: _emailController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _passwordController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Confirm Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _confirmPasswordController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Date of Birth',
//           icon: Icons.date_range,
//           controller: _dobController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'CNIC',
//           icon: Icons.credit_card,
//           controller: _cnicController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Phone Number',
//           icon: Icons.phone,
//           controller: _phoneController,
//         ),
//         SizedBox(height: 16.0),
//         Row(
//           children: [
//             Text('Gender: '),
//             Radio(
//               value: 'Male',
//               groupValue: _gender,
//               onChanged: (value) {
//                 setState(() {
//                   _gender = value.toString();
//                 });
//               },
//             ),
//             Text('Male'),
//             Radio(
//               value: 'Female',
//               groupValue: _gender,
//               onChanged: (value) {
//                 setState(() {
//                   _gender = value.toString();
//                 });
//               },
//             ),
//             Text('Female'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDoctorSignupForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CustomTextBox(
//           label: 'Full Name',
//           icon: Icons.person,
//           controller: _fullNameController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Email',
//           icon: Icons.email,
//           controller: _emailController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _passwordController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Confirm Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _confirmPasswordController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Date of Birth',
//           icon: Icons.date_range,
//           controller: _dobController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'CNIC',
//           icon: Icons.credit_card,
//           controller: _cnicController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Phone Number',
//           icon: Icons.phone,
//           controller: _phoneController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Specialization',
//           icon: Icons.assignment_ind,
//           controller: _specializationController,
//         ),
//         SizedBox(height: 16.0),
//         Row(
//           children: [
//             Text('Gender: '),
//             Radio(
//               value: 'Male',
//               groupValue: _gender,
//               onChanged: (value) {
//                 setState(() {
//                   _gender = value.toString();
//                 });
//               },
//             ),
//             Text('Male'),
//             Radio(
//               value: 'Female',
//               groupValue: _gender,
//               onChanged: (value) {
//                 setState(() {
//                   _gender = value.toString();
//                 });
//               },
//             ),
//             Text('Female'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLabSignupForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CustomTextBox(
//           label: 'Lab Name',
//           icon: Icons.business,
//           controller: _labNameController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Address',
//           icon: Icons.location_on,
//           controller: _addressController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Email',
//           icon: Icons.email,
//           controller: _emailController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _passwordController,
//         ),
//         SizedBox(height: 16.0),
//         CustomTextBox(
//           label: 'Confirm Password',
//           icon: Icons.lock,
//           isPassword: true,
//           controller: _confirmPasswordController,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Signup'),
//       ),
//       body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               DropdownButton<String>(
//                 value: _selectedOption,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedOption = newValue!;
//                   });
//                 },
//                 items: <String>[
//                   'Patient Signup',
//                   'Doctor Signup',
//                   'Lab Signup',
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 16.0),
//               _buildForm(),
//               SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Sign Up',
//                 onPressed: () {
//                   if (_selectedOption == 'Patient Signup') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen(token: 'abc',)),
//                     );
//                   }
//                 },
//                 color: Color(0xFF199A8E), // Set background color similar to splash screen
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/CustomWidgets/CustomTextBox.dart';
import 'package:fyp/CustomWidgets/CustomButton.dart';
import 'package:fyp/screens/PHR/Home.dart';
import 'package:fyp/services/API/SignupService.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _selectedOption = 'Patient Signup';
  String _gender = '';
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mrId = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final SignupService _signupService = SignupService();

  DateTime _selectedDate = DateTime.now(); // initialize with current date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = _formatDate(pickedDate); // Update formatted date after selection
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(date) + 'Z';
  }

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
          controller: _fullNameController,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Email',
          icon: Icons.email,
          controller: _emailController,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
          controller: _passwordController,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
          controller: _confirmPasswordController,
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                height: 60,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _dobController.text.isEmpty
                    ? Row(
                  children: [
                    Icon(Icons.edit_calendar_rounded),
                    SizedBox(width: 10.0),
                    Text(
                      'Select Date',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                )
                    : Text(
                  _dobController.text,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'CNIC',
          icon: Icons.credit_card,
          controller: _cnicController,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'mrid',
          icon: Icons.phone,
          controller: _mrId,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Phone Number',
          icon: Icons.phone,
          controller: _phoneController,
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
      controller: _fullNameController,
    ),
    SizedBox(height: 16.0),
    CustomTextBox(
    label: 'Email',
    icon: Icons.email,
    controller: _emailController,
    ),
    SizedBox(height: 16.0),
    CustomTextBox(
    label: 'Password',
    icon: Icons.lock,
    isPassword: true,
    controller:            _passwordController,
    ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
          controller: _confirmPasswordController,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Specialization',
          icon: Icons.assignment_ind,
          controller: _specializationController,
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                height: 60,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _dobController.text.isEmpty
                    ? Row(
                  children: [
                    Icon(Icons.edit_calendar_rounded),
                    SizedBox(width: 10.0),
                    Text(
                      'Select Date',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                )
                    : Text(
                  _dobController.text,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'CNIC',
          icon: Icons.credit_card,
          controller: _cnicController,
        ),SizedBox(height: 16.0),
        CustomTextBox(
          label: 'mrid',
          icon: Icons.phone,
          controller: _mrId,
        ),
        SizedBox(height: 16.0),
        CustomTextBox(
          label: 'Phone Number',
          icon: Icons.phone,
          controller: _phoneController,
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
    return Container(); // Implement Lab Signup Form
  }

  Future<void> _signup() async {
    try {
      if (_selectedOption == 'Patient Signup') {
        Map<String, dynamic> patientData = {
          "phone": _phoneController.text,
          "email": _emailController.text,
          "gender": _gender,
          "cnic": _cnicController.text,
          "name": _fullNameController.text,
          "password": _passwordController.text,
          "dob": _formatDate(_selectedDate),  // Convert DateTime to String
          "mrId": int.tryParse(_mrId.text)
        };

        await _signupService.createPatient(patientData);

        // Navigate to home screen after successful signup
        final token = 'SD21rfjuBdOXSlbbOm0ee52UXnz2'; // Hardcoded token
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
        );
      } else if (_selectedOption == 'Doctor Signup') {
        Map<String, dynamic> doctorData = {
          "phone": _phoneController.text,
          "email": _emailController.text,
          "gender": _gender,
          "cnic": _cnicController.text,
          "name": _fullNameController.text,
          "password": _passwordController.text,
          "dob": _formatDate(_selectedDate),  // Convert DateTime to String
          "mrId": int.tryParse(_mrId.text),
          "specialization": _specializationController.text,
        };

        await _signupService.createDoctor(doctorData);



        // Navigate to home screen after successful signup
        final token = 'SD21rfjuBdOXSlbbOm0ee52UXnz2'; // Hardcoded token
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
        );
      } else if (_selectedOption == 'Lab Signup') {
        // Implement Lab Signup API Call
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: SingleChildScrollView(
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
                color: Color(0xFF199A8E),
                text: 'Sign Up',
                onPressed: _signup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

