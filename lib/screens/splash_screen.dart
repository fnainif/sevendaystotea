import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme.dart';
import 'main_menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dropPositionAnimation;
  late Animation<double> _dropOpacityAnimation;
  late Animation<double> _teapotRotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _dropPositionAnimation = Tween<double>(begin: -30.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
      ),
    );

    _dropOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _teapotRotationAnimation = Tween<double>(begin: 0.0, end: math.pi / 6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _navigateToHome();
  }

  void _navigateToHome() async {
    try {
      await Future.delayed(const Duration(seconds: 4));
    } catch (e) {
      debugPrint("Error during splash screen delay: $e");
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) => const MainMenuScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DuchessTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cup
                  Positioned(
                    bottom: 20,
                    child: Icon(
                      Icons.local_cafe,
                      size: 64,
                      color: DuchessTheme.primary,
                    ),
                  ),
                  // Teapot/Pouring source
                  Positioned(
                    top: 10,
                    right: 20,
                    child: AnimatedBuilder(
                      animation: _teapotRotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: -_teapotRotationAnimation.value,
                          child: Icon(
                            Icons.coffee_maker,
                            size: 48,
                            color: DuchessTheme.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                  // Water drop
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        top: 60 + _dropPositionAnimation.value,
                        right: 60,
                        child: Opacity(
                          opacity: _dropOpacityAnimation.value,
                          child: Icon(
                            Icons.water_drop,
                            size: 24,
                            color: DuchessTheme.goldAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Brewing tea...",
              style: DuchessTheme.headlineLg(color: DuchessTheme.primary),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(DuchessTheme.goldAccent),
            ),
          ],
        ),
      ),
    );
  }
}
