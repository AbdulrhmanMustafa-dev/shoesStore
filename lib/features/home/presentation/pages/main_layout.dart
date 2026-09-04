import 'package:flutter/material.dart';
import 'package:kicksvibe/features/home/presentation/pages/home_screen.dart';
import 'package:kicksvibe/features/home/presentation/widgets/menu_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  // دالة للوصول إلى State الخاصة بالـ Layout من أي مكان بداخله
  static MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainLayoutState>();
  }

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void toggleMenu() {
    if (_isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // 1. القائمة الجانبية (في الخلفية)
          const MenuScreen(),

          // 2. الشاشة الرئيسية (في المقدمة مع تأثير 3D)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final double slide = 250.0 * _animationController.value;
              final double scale =
                  1 - (_animationController.value * 0.15); // تصغير الشاشة 15%
              final double rotate =
                  _animationController.value * -0.05; // دوران 3D خفيف

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.001,
                  ) // تفعيل منظور البعد الثالث (Perspective)
                  ..rotateY(rotate)
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_isMenuOpen ? 30 : 0),
                  child: GestureDetector(
                    onTap: () {
                      if (_isMenuOpen) {
                        toggleMenu(); // إغلاق القائمة عند لمس الشاشة الرئيسية
                      }
                    },
                    child: AbsorbPointer(
                      // منع التفاعل مع الشاشة الرئيسية والقائمة مفتوحة
                      absorbing: _isMenuOpen,
                      child: const HomeScreen(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
