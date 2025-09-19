import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackgroundImage(
        asset: 'assets/ui/tobe.jpg',
        child: Center(
          child: Text('Drums', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}