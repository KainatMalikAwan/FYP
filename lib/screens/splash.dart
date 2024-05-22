import 'package:flutter/material.dart';
import 'Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  void _navigateToLoginScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF199A8E), // Set background color to #199A8E
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Replace with path to your logo image asset
          width: 300, // Set desired width of the logo
          height: 300, // Set desired height of the logo
        ),
      ),
    );
  }
}
