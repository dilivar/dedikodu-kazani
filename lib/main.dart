import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/theme/colors.dart';
import 'package:dedikodu_kazani/screens/login_screen.dart';

void main() {
  runApp(const DedikoduKazaniApp());
}

class DedikoduKazaniApp extends StatelessWidget {
  const DedikoduKazaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dedikodu Kazanı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: ThemeColors.background,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
