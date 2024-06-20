import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
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
