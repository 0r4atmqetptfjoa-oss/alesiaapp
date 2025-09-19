import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/kid_card.dart';
import '../widgets/adaptive.dart';
import '../../services/audio_manager.dart';

class Animal {
  final String name;
  final String imageAsset; // e.g. assets/images/animals/cow.png
  final String audioAsset; // e.g. assets/audio/instruments/C.wav
  final String category;
  const Animal(this.name, this.imageAsset, this.audioAsset, this.category);
}

// Demo list with two categories.
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: adaptiveCrossAxisCount(context, minTileWidth: 260),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final animal = items[index];
          return KidCard(
            title: animal.name,
            imageAsset: animal.imageAsset,
            badgeText: '#${index + 1}',
            onTap: () async => await audioManager.play(animal.audioAsset),
          );
        },
      ),
    );
  }
}