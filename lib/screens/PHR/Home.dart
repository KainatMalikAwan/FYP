import 'package:flutter/material.dart';
import 'package:fyp/CustomWidgets/CustomBottomNavBar.dart';
import 'package:fyp/CustomWidgets/CustomAppBarIconButton.dart';
import 'package:fyp/CustomWidgets/AddVitalsPopUp.dart'; // Import your custom pop-up

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isPlusClicked = false;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo2.png', // Adjust the path to your logo
              width: 32, // Adjust the width of the logo as needed
              height: 32, // Adjust the height of the logo as needed
            ),
            SizedBox(width: 8),
            Text('PHR',
              style: TextStyle(
                  fontSize: 25, // Adjust the font size as needed
                  fontWeight: FontWeight.bold
              ),),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Add New Vital  ',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                       fontWeight: FontWeight.bold
                    ),
                  ),

                  CustomAppBarIconButton(
                    isPlusClicked: _isPlusClicked,
                    onTap: _togglePlusClicked,
                    icon: _isPlusClicked ? Icons.close : Icons.add,
                  ),
                  SizedBox(width: 16.0), // Adjust the width as needed
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
       
      ),

      bottomNavigationBar: CustomBottomNavBar(
        icons: [
          Icons.favorite,
          Icons.bar_chart,
          Icons.share,
          Icons.person,
        ],
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
