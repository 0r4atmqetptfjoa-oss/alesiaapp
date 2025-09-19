import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../../data/stories_repository.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});
  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  late Future _future;
  @override
  void initState() {
    super.initState();
    _future = storiesRepo.loadStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              onAnimals: () => Navigator.pushReplacementNamed(context, '/animals'),
              onSongs: () => Navigator.pushReplacementNamed(context, '/songs'),
              onGames: () => Navigator.pushReplacementNamed(context, '/games'),
              onStories: () {},
              onParents: () => Navigator.pushReplacementNamed(context, '/parents'),
            ),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (context, snap) {
                  final list = (snap.data ?? const []) as List;
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, i) => Material(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(18),
                      child: ListTile(
                        title: Text(list[i].title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(list[i].body, maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(list[i].title),
                            content: SingleChildScrollView(child: Text(list[i].body)),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: list.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}