import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/screens/home_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
