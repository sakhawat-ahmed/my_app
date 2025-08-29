import 'package:flutter/material.dart';

class SplashLogoAnimation extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashLogoAnimation({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(
              Icons.menu_book_rounded,
              size: 80,
              color: Colors.white,
            ),
            Positioned(
              top: 10,
              child: Container(
                width: 120,
                height: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: 120,
                height: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}