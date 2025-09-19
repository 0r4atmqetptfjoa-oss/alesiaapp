import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/animated_hover_scale.dart';
import '../../services/audio_manager.dart';

class Animal {
  final String name;
  final String imageAsset; // e.g. assets/images/animals/cow.png
  final String audioAsset; // e.g. assets/audio/instruments/C.wav (kept simple for demo)
  final String category;
  const Animal(this.name, this.imageAsset, this.audioAsset, this.category);
}

// Demo list with two categories. Images are provided in the zip.
final List<Animal> animals = [
  Animal('Vaca', 'assets/images/animals/cow.png', 'assets/audio/instruments/C.wav', 'Ferma'),
  Animal('Oaie', 'assets/images/animals/sheep.png', 'assets/audio/instruments/D.wav', 'Ferma'),
  Animal('Porc', 'assets/images/animals/pig.png', 'assets/audio/instruments/E.wav', 'Ferma'),
  Animal('Leu', 'assets/images/animals/lion.png', 'assets/audio/instruments/F.wav', 'Sălbatic'),
  Animal('Elefant', 'assets/images/animals/elephant.png', 'assets/audio/instruments/G.wav', 'Sălbatic'),
  Animal('Maimuță', 'assets/images/animals/monkey.png', 'assets/audio/instruments/A.wav', 'Sălbatic'),
];

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = animals.map((a) => a.category).toSet().toList();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.85),
                borderRadius: BorderRadius.circular(Radii.xl),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.textDark,
                indicator: BoxDecoration(
                  color: AppColors.leaf1.withOpacity(.35),
                  borderRadius: BorderRadius.circular(Radii.xl),
                ),
                tabs: [for (var c in categories) Tab(text: c)],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (var c in categories) _buildCategory(c),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String category) {
    final items = animals.where((a) => a.category == category).toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final animal = items[index];
          return AnimatedHoverScale(
            onTap: () async => await audioManager.play(animal.audioAsset),
            child: Material(
              color: Colors.white,
              elevation: 6,
              borderRadius: BorderRadius.circular(Radii.lg),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      animal.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Center(
                        child: Icon(Icons.pets_rounded, size: 64, color: AppColors.leaf2),
                      ),
                    ),
                  ),
                  // Bottom label strip
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.85),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        animal.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}