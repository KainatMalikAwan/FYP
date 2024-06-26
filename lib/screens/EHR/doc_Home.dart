import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ThemeSettings/ThemeSettings.dart';
import '../splash.dart';

class EHRWelcomeScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    // Clear all data from shared preferences
    await _prefs.clear();

    // Navigate to SplashScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeSettings.bgcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to EHR',
              style: TextStyle(
                fontSize: 36,
                color: ThemeSettings.labelColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
