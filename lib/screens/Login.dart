//
//
//
//
//
//
//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fyp/Services/API/AuthAPI.dart';
// import 'package:fyp/screens/PHR/Home.dart';
// import 'package:fyp/screens/SignupScreen.dart';
// import 'package:fyp/CustomWidgets/CustomTextBox.dart'; // Import your custom text box
// import 'package:fyp/CustomWidgets/CustomButton.dart'; // Import your custom button
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String _errorMessage = '';
//
//   final AuthAPI authAPI = AuthAPI();
//
//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     final String email = _emailController.text;
//     final String password = _passwordController.text;
//
//     try {
//       final response = await authAPI.signIn(email, password);
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         final token = responseData['data']['token'];
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
//         );
//       } else {
//         setState(() {
//           _errorMessage = 'Login failed. Please check your credentials.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred. Please try again later.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "Let’s get started!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Text(
//                 "Login to enjoy the features we’ve provided, and stay healthy!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               CustomTextBox(
//                 label: 'Username or Email',
//                 icon: Icons.person,
//                 controller: _emailController,
//               ),
//               SizedBox(height: 16.0),
//               CustomTextBox(
//                 label: 'Password',
//                 icon: Icons.lock,
//                 isPassword: true,
//                 controller: _passwordController,
//               ),
//               SizedBox(height: 16.0),
//               TextButton(
//                 onPressed: () {
//                   // Add forgot password logic here
//                 },
//                 child: Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFF199A8E),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               if (_isLoading)
//                 Center(child: CircularProgressIndicator())
//               else
//                 CustomButton(
//                   text: 'Login',
//                   onPressed: _login,
//                   color: Color(0xFF199A8E),
//                 ),
//               if (_errorMessage.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: Text(
//                     _errorMessage,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               SizedBox(height: 16.0),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignupScreen()),
//                   );
//                 },
//                 child: Text(
//                   "Don’t have an account? Sign Up",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.blue,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: LoginScreen(),
//   ));
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/Services/API/AuthAPI.dart';
import 'package:fyp/screens/PHR/Home.dart';
import 'package:fyp/screens/SignupScreen.dart';
import 'package:fyp/CustomWidgets/CustomTextBox.dart'; // Import your custom text box
import 'package:fyp/CustomWidgets/CustomButton.dart'; // Import your custom button

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  final AuthAPI authAPI = AuthAPI();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await authAPI.signIn(email, password);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        final user = responseData['data']['user'];

        // Save token and user data in shared preferences
        await _prefs.setString('token', token);
        await _prefs.setInt('userId', user['id']);
        await _prefs.setString('email', user['email']);
        await _prefs.setString('phone', user['phone']);
        await _prefs.setString('cnic', user['cnic']);

        // If the user is a patient, save patient-specific data
        if (user['role'] == 'patient') {
          final patientData = user['patients'][0];
          await _prefs.setString('fullName', patientData['name']);
          await _prefs.setString('dob', patientData['dob']);
          await _prefs.setString('gender', patientData['gender']);
          await _prefs.setString('relation', patientData['relation']);

        }

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
        );
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Let’s get started!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Login to enjoy the features we’ve provided, and stay healthy!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              CustomTextBox(
                label: 'Username or Email',
                icon: Icons.person,
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
              TextButton(
                onPressed: () {
                  // Add forgot password logic here
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF199A8E),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                CustomButton(
                  text: 'Login',
                  onPressed: _login,
                  color: Color(0xFF199A8E),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(
                  "Don’t have an account? Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
