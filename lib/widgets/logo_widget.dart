import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  
  const LogoWidget({super.key, this.size = 100});

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
          colors: [
            Color(0xFFE91E63), // Pink
            Color(0xFF9C27B0), // Purple
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan chat bubbles
          Positioned(
            top: size * 0.1,
            right: size * 0.15,
            child: Container(
              width: size * 0.25,
              height: size * 0.2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(size * 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: size * 0.15,
            left: size * 0.1,
            child: Container(
              width: size * 0.2,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          // Ana D harfi
          Text(
            'D',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Ana ekran için kullanım:
/*
LogoWidget(size: 120)
*/
