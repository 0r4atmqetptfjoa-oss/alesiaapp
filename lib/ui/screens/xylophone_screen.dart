import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackgroundImage(
        asset: 'assets/ui/xilofon.jpg',
        child: Center(
          child: Text('Xylophone', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}