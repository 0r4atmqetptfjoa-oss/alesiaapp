import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/animals_repository.dart';
import '../../models/animal.dart';
import '../../services/audio_sfx.dart';
import '../widgets/common_widgets.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});
  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  late Future<List<AnimalItem>> _future;
  @override
  void initState() {
    super.initState();
    _future = animalsRepo.loadAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: ForestBackground(
          child: Column(
            children: [
              RibbonBar(
                onHome: () => Navigator.pushReplacementNamed(context, '/'),
                onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
                onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
                onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
                onParents: () => Navigator.pushReplacementNamed(context, '/parents'),
              ),
              const SizedBox(height: 4),
              Material(
                type: MaterialType.transparency,
                child: TabBar(
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  tabs: const [ Tab(text: 'Sălbatice'), Tab(text: 'Fermă'), Tab(text: 'Marine') ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<AnimalItem>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final list = snap.data ?? [];
                    final wild   = list.where((e) => e.category.toLowerCase().contains('sălb') || e.category.toLowerCase().contains('salb')).toList();
                    final farm   = list.where((e) => e.category.toLowerCase().contains('ferm')).toList();
                    final marine = list.where((e) => e.category.toLowerCase().contains('marin')).toList();
                    return TabBarView(
                      children: [
                        _AnimalsGrid(items: wild),
                        _AnimalsGrid(items: farm),
                        _AnimalsGrid(items: marine),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimalsGrid extends StatelessWidget {
  final List<AnimalItem> items;
  const _AnimalsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w > 1200 ? 7 : w > 900 ? 5 : w > 600 ? 4 : 3;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .9),
        itemCount: items.length,
        itemBuilder: (_, i) => _AnimalTile(item: items[i]),
      ),
    );
  }
}

class _AnimalTile extends StatefulWidget {
  final AnimalItem item;
  const _AnimalTile({required this.item});

  @override
  State<_AnimalTile> createState() => _AnimalTileState();
}

class _AnimalTileState extends State<_AnimalTile> {
  bool _pressed = false;
  double _tiltX = 0, _tiltY = 0;

  void _play() async {
    setState(() => _pressed = true);
    await audioSfx.playAssetPath(widget.item.audio);
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item.name;
    return Listener(
      onPointerHover: (ev) {
        const size = 120.0;
        setState(() {
          _tiltX = ((ev.localPosition.dy - size/2) / size) * -4;
          _tiltY = ((ev.localPosition.dx - size/2) / size) * 4;
        });
      },
      onPointerExit: (_) => setState(() { _tiltX = 0; _tiltY = 0; }),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _play,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(_tiltX * math.pi / 180)
                        ..rotateY(_tiltY * math.pi / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(widget.item.image, fit: BoxFit.contain, height: 90),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, height: 1.1)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.item.audio == null ? Icons.volume_off_rounded : Icons.volume_up_rounded, size: 18, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(widget.item.audio == null ? 'Fără sunet' : 'Sunet', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    )
                  ],
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _pressed ? 0.35 : 0.0,
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(colors: [Color(0x66FFFFFF), Color(0x00000000)], radius: 0.85),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}