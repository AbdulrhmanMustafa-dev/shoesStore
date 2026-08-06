import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Colors.black87,
        ),
      ),
    );
  }
}
