import 'package:flutter/material.dart';
import '../../data/content_repository.dart';
import '../../models/story.dart';
import '../widgets/common_widgets.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<Story> _stories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await contentRepo.loadStories();
    setState(() {
      _stories = s;
      _loading = false;
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
          Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) : _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_stories.isEmpty) {
      return const Center(child: Text('Nu am găsit assets/content/stories.json — folosesc conținutul existent.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _stories.length,
      itemBuilder: (_, i) {
        final s = _stories[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(s.title),
            subtitle: Text(s.source),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: s.paragraphs.map((p)=> Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(p, textAlign: TextAlign.start),
                  )).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}