import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart';

class ColorPickerScreen extends StatefulWidget {
  @override
  _ColorPickerScreenState createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  void _showColorPicker(BuildContext context, Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pick Colors'),
            backgroundColor: themeProvider.foregroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Foreground Color',
                  style: TextStyle(color: themeProvider.textColor),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker(
                      context,
                      themeProvider.foregroundColor,
                          (color) {
                        themeProvider.setForegroundColor(color);
                      },
                    );
                  },
                  child: Text('Select Foreground Color'),
                  style: ElevatedButton.styleFrom(primary: themeProvider.foregroundColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Background Color',
                  style: TextStyle(color: themeProvider.textColor),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker(
                      context,
                      themeProvider.backgroundColor,
                          (color) {
                        themeProvider.setBackgroundColor(color);
                      },
                    );
                  },
                  child: Text('Select Background Color'),
                  style: ElevatedButton.styleFrom(primary: themeProvider.backgroundColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Text Color',
                  style: TextStyle(color: themeProvider.textColor),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker(
                      context,
                      themeProvider.textColor,
                          (color) {
                        themeProvider.setTextColor(color);
                      },
                    );
                  },
                  child: Text('Select Text Color'),
                  style: ElevatedButton.styleFrom(primary: themeProvider.textColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
