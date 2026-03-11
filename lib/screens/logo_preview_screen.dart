import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/widgets/logo_alternatives.dart';

class LogoPreviewScreen extends StatelessWidget {
  const LogoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logo Alternatifleri'),
        backgroundColor: Colors.pink[300],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Logo 1: D Harfi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(child: Logo1(size: 120)),
          const SizedBox(height: 40),
          
          const Text('Logo 2: Konuşma Grubu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(child: Logo2(size: 120)),
          const SizedBox(height: 40),
          
          const Text('Logo 3: Kalp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(child: Logo3(size: 120)),
          const SizedBox(height: 40),
          
          const Text('Logo 4: Modern Daire', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(child: Logo4(size: 120)),
          const SizedBox(height: 40),
          
          const Text('Logo 5: AI (A Harfi)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(child: Logo5(size: 120)),
        ],
      ),
    );
  }
}
