import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  // Alterna entre os temas claro e escuro
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanchonete da Carminha',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'BebasNeue',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BebasNeue',
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(toggleTheme: toggleTheme),
    );
  }
}