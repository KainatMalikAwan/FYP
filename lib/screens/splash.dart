import 'package:flutter/material.dart';
import 'package:fyp/screens/EHR/doc_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart'; // Assuming LoginScreen is imported from Login.dart
import 'package:fyp/screens/PHR/Home.dart';
import 'PHR/Home.dart'; // Assuming HomeScreen is imported from Home.dart

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefsAndNavigate();
  }

  Future<void> _loadPrefsAndNavigate() async {
    _prefs = await SharedPreferences.getInstance();

    // Check if there is a token stored in SharedPreferences
    String? token = _prefs.getString('token');

    // Delay for 2 seconds to show splash screen
    await Future.delayed(Duration(seconds: 2));

    // Navigate to appropriate screen based on SharedPreferences data
    if (token != null && token.isNotEmpty) {


      // Navigate to HomeScreen if token exists
       bool? isPatient=await _prefs.getBool('isPatient');
       if(isPatient?? false){
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
         );
       }else{ Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) =>EHRWelcomeScreen()),
       );}

    } else {
      // Navigate to LoginScreen if token does not exist
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF199A8E), // Set background color to #199A8E
      body: Center(
        child: Image.asset(
          'assets/images/go.png', // Replace with path to your logo image asset
          width: 300, // Set desired width of the logo
          height: 300, // Set desired height of the logo
        ),
      ),
    );
  }
}
