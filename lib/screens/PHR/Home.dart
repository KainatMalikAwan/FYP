import 'package:flutter/material.dart';
import 'package:fyp/CustomWidgets/CustomBottomNavBar.dart';
import 'package:fyp/CustomWidgets/CustomAppBarIconButton.dart';
import 'package:fyp/CustomWidgets/AddVitalsPopUp.dart';
import 'package:fyp/screens/PHR/Vitals.dart';
import 'package:fyp/screens/PHR/OCR.dart';
import 'package:fyp/screens/PHR/patientProfile.dart';
import 'package:fyp/screens/PHR/Reports.dart';
import 'package:fyp/Services/API/AuthAPI.dart';
import 'package:fyp/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../temp.dart';
import '../../test.dart';
import '../Login.dart';
import 'package:fyp/screens/PHR/Graphs.dart';

class HomeScreen extends StatefulWidget {
  final String token; // Pass the token from login
  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isPlusClicked = false;

  PageController _pageController = PageController();
  late SharedPreferences _prefs; // Define _prefs here

  @override
  void initState() {
    super.initState();
    _initPreferences(); // Initialize _prefs
  }

  void _initPreferences() async {
    _prefs = await SharedPreferences.getInstance(); // Initialize _prefs
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _togglePlusClicked() {
    setState(() {
      _isPlusClicked = !_isPlusClicked;
    });
    if (_isPlusClicked) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: CustomAddVitalsPopUp(
              onClose: () {
                setState(() {
                  _isPlusClicked = false;
                });
              },
            ),
          );
        },
      ).then((_) {
        setState(() {
          _isPlusClicked = false;
        });
      });
    }
  }

  Future<void> _logout() async {
    // Check if _prefs is initialized
    if (_prefs != null) {
      // Clear all data from shared preferences
      await _prefs.clear();

      // Navigate to SplashScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo2.png',
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'PHR',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadDataScreen()),
                      );
                    },
                    child: Text(
                      'Add New Vital',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomAppBarIconButton(
                    isPlusClicked: _isPlusClicked,
                    onTap: _togglePlusClicked,
                    icon: _isPlusClicked ? Icons.close : Icons.add,
                  ),
                  SizedBox(width: 16.0),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          MedicalScreen(),
          VitalsScreen(),
          VitalsGraphScreen(),
          PatientProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        icons: [
          Icons.home,
          Icons.favorite,
          Icons.bar_chart,
          Icons.person,
        ],
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
