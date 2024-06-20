import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ColorPickerScreen.dart';
import 'ThemeProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EHR with PHR',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF199A8E)),
              useMaterial3: true,
              primaryColor: themeProvider.foregroundColor,
              scaffoldBackgroundColor: themeProvider.backgroundColor,
              textTheme: TextTheme(
                bodyText1: TextStyle(color: themeProvider.textColor),
                bodyText2: TextStyle(color: themeProvider.textColor),
              ),
            ),
            home: ColorPickerScreen(),
          );
        },
      ),
    );
  }
}
