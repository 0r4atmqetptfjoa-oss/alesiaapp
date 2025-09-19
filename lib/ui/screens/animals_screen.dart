import 'package:flutter/material.dart';
import '../../data/animals_repository.dart';
import '../../models/animal.dart';
import '../widgets/common_widgets.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});
  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  List<AnimalItem> animals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await animalsRepo.loadAnimals();
    setState(() { animals = list; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return ForestBackground(
      child: Column(
        children: [
          RibbonBar(
            onHome: () => Navigator.pushReplacementNamed(context, '/'),
            onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
            onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
            onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
            onParents: () => Navigator.pushReplacementNamed(context, '/parents'),
          ),
          Expanded(child: loading ? const Center(child: CircularProgressIndicator()) : _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (animals.isEmpty) {
      return const Center(child: Text('Nu am găsit assets/content/animals.json — folosesc fallback.'));
    }
    final byCat = <String, List<AnimalItem>>{};
    for (final a in animals) {
      byCat.putIfAbsent(a.category, () => []).add(a);
    }
    final cats = byCat.keys.toList()..sort();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [ for (final c in cats) _section(c, byCat[c]!) ],
    );
  }

  Widget _section(String title, List<AnimalItem> list) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Icon(Icons.pets_rounded), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                int columns = 2;
                if (w > 1200) columns = 5;
                else if (w > 900) columns = 4;
                else if (w > 600) columns = 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns, childAspectRatio: 1, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _tile(list[i]),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _tile(AnimalItem a) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(a.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}