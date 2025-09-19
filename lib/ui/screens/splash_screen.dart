import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
    // Navigate after a short delay.
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSky,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative gradient
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.bgGradient),
          ),
          // Center logo + title
          Center(
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Text('Muzica Magica',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const LinearProgressIndicator(minHeight: 6, backgroundColor: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}