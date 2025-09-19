import 'package:flutter/material.dart';
import '../../../data/content_repository.dart';
import '../../../models/game_levels.dart';
import '../../widgets/common_widgets.dart';

class GamesHomeScreen extends StatefulWidget {
  const GamesHomeScreen({super.key});
  @override
  State<GamesHomeScreen> createState() => _GamesHomeScreenState();
}

class _GamesHomeScreenState extends State<GamesHomeScreen> {
  List<MemoryLevel> mem = [];
  List<AlphabetLevel> abc = [];
  List<NumbersLevel> num = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await contentRepo.loadGamesRaw();
    setState(() {
      mem = (raw['memory_levels'] as List? ?? []).map((e)=> MemoryLevel.fromJson(e)).toList();
      abc = (raw['alphabet_levels'] as List? ?? []).map((e)=> AlphabetLevel.fromJson(e)).toList();
      num = (raw['numbers_levels'] as List? ?? []).map((e)=> NumbersLevel.fromJson(e)).toList();
      loading = false;
    });
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
    if (mem.isEmpty && abc.isEmpty && num.isEmpty) {
      return const Center(child: Text('Nu am găsit assets/content/games.json — folosesc grila existentă.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (mem.isNotEmpty) _section('Memorie', mem.map((e)=> e.name).toList(), Icons.grid_view_rounded),
        if (abc.isNotEmpty) _section('Alfabet', abc.map((e)=> e.id.replaceAll('_',' ').toUpperCase()).toList(), Icons.abc_rounded),
        if (num.isNotEmpty) _section('Numere', num.map((e)=> '${e.id} (${e.goal})').toList(), Icons.onetwothree_rounded),
      ],
    );
  }

  Widget _section(String title, List<String> items, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: items.map((t)=> Chip(label: Text(t))).toList(),
            )
          ],
        ),
      ),
    );
  }
}