import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

/// A simple representation of an animal item. Each animal has a
/// display name and an audio asset. IconData is used for the
/// placeholder visual on the card; custom images can be used via
/// AssetImage if desired.
class Animal {
  final String name;
  final IconData icon;
  final String audioAsset;
  final String category;
  Animal(this.name, this.icon, this.audioAsset, this.category);
}

/// Sample list of animals separated by category. In a real app
/// these would be generated via content packs or a database.
final List<Animal> animals = [
  Animal('Vaca', Icons.pets, 'assets/audio/instruments/C.wav', 'Ferma'),
  Animal('Oaie', Icons.pets, 'assets/audio/instruments/D.wav', 'Ferma'),
  Animal('Porc', Icons.pets, 'assets/audio/instruments/E.wav', 'Ferma'),
  Animal('Leu', Icons.pets, 'assets/audio/instruments/F.wav', 'Salbatic'),
  Animal('Elefant', Icons.pets, 'assets/audio/instruments/G.wav', 'Salbatic'),
  Animal('Maimuță', Icons.pets, 'assets/audio/instruments/A.wav', 'Salbatic'),
];

/// Displays animals grouped by category. Tapping an animal will
/// animate the card and (later) play an associated sound.
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
              onSounds: () {},
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.textDark,
              indicatorColor: AppColors.green,
              tabs: [for (var c in categories) Tab(text: c)],
            ),
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
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final animal = items[index];
          return _AnimalCard(animal: animal);
        },
      ),
    );
  }
}

class _AnimalCard extends StatefulWidget {
  const _AnimalCard({required this.animal});
  final Animal animal;

  @override
  State<_AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<_AnimalCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 90));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    // Play the animal's sound using the global audio manager. The
    // audioAsset property already contains the full asset path.
    await audioManager.play(widget.animal.audioAsset);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _onTap(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: .95).animate(_controller),
        child: Material(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(Radii.lg),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.animal.icon, size: 48, color: AppColors.leaf2),
                const SizedBox(height: 12),
                Text(
                  widget.animal.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}