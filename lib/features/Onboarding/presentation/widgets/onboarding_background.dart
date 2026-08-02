import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الدائرة العلوية
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8F1FC),
            ),
          ),
        ),

        // كلمة NIKE الباهتة
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'NIKE',
              style: TextStyle(
                fontSize: 140,
                fontWeight: FontWeight.w900,
                color: Colors.grey.withValues(alpha: 0.05),
                letterSpacing: 10,
              ),
            ),
          ),
        ),

        // النقاط العائمة
        const Positioned(
          top: 120,
          left: 40,
          child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF8BB5E9)),
        ),
        const Positioned(
          bottom: 300,
          right: 50,
          child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF8BB5E9)),
        ),
        const Positioned(
          bottom: 100,
          left: 60,
          child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF8BB5E9)),
        ),

        // المحتوى الأساسي
        SafeArea(child: child),
      ],
    );
  }
}
