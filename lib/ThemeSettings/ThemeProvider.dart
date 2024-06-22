import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {

  Color buttonColor = Colors.blue; // Variable to store button color
  Color labelColor = Colors.black; // Variable to store label color
  Color buttonTextColor = Colors.white; // Variable to store button text color
  Color bgcolor=Colors.pink;
  Color _foregroundColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;

  Color get foregroundColor => _foregroundColor;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  void setForegroundColor(Color color) {
    _foregroundColor = color;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }
}
