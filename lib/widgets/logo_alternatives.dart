import 'package:flutter/material.dart';

// ============ LOGO 1: D Harfi (Mevcut) ============
class Logo1 extends StatelessWidget {
  final double size;
  const Logo1({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text('D', style: TextStyle(fontSize: size*0.5, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

// ============ LOGO 2: Konuşma Balonu ============
class Logo2 extends StatelessWidget {
  final double size;
  const Logo2({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4081).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: size * 0.1,
            top: size * 0.15,
            child: Icon(Icons.chat_bubble, color: Colors.white.withOpacity(0.3), size: size * 0.4),
          ),
          Center(
            child: Icon(Icons.people, color: Colors.white, size: size * 0.5),
          ),
        ],
      ),
    );
  }
}

// ============ LOGO 3: Kalp + Chat ============
class Logo3 extends StatelessWidget {
  final double size;
  const Logo3({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B6B), Color(0xFFE91E63)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.favorite, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}

// ============ LOGO 4: Modern Daire ============
class Logo4 extends StatelessWidget {
  final double size;
  const Logo4({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8BBD9), Color(0xFFE91E63)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.chat, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}

// ============ LOGO 5: A harfi (AI) ============
class Logo5 extends StatelessWidget {
  final double size;
  const Logo5({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: size * 0.1,
            bottom: size * 0.1,
            child: Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.5), size: size * 0.25),
          ),
          Center(
            child: Text('A', style: TextStyle(fontSize: size*0.5, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
