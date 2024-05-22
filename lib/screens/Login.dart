import 'package:flutter/material.dart';
import 'package:fyp/screens/PHR/Home.dart';
import 'package:fyp/screens/SignupScreen.dart';
import 'package:fyp/CustomWidgets/CustomTextBox.dart';
import 'package:fyp/CustomWidgets/CustomButton.dart'; // Import the CustomButton widget

class LoginScreen extends StatelessWidget {
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
              ),
              SizedBox(height: 16.0),
              CustomTextBox(
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
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
                    color: Color(0xFF199A8E), // Set color similar to button background
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to SignupScreen
                  );
                },
                color: Color(0xFF199A8E), // Set background color similar to splash screen
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()), // Navigate to SignupScreen
                  );
                },
                child: Text(
                  "Don’t have an account? Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // Set color for clickable text
                    decoration: TextDecoration.underline, // Add underline for indication
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
