import 'package:flutter/material.dart';
import '../../services/audio_sfx.dart';
import '../../data/songs_repository.dart';
import '../widgets/common_widgets.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  late Future<List<SongItem>> _future;
  @override
  void initState() {
    super.initState();
    _future = songsRepo.loadSongs();
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
              onSongs: () {},
              onGames: () => Navigator.pushReplacementNamed(context, '/games'),
              onStories: () => Navigator.pushReplacementNamed(context, '/stories'),
              onParents: () => Navigator.pushReplacementNamed(context, '/parents'),
            ),
            Expanded(
              child: FutureBuilder<List<SongItem>>(
                future: _future,
                builder: (context, snap) {
                  final list = snap.data ?? const [];
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, i) => Material(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.primaries[i % Colors.primaries.length],
                          child: Text('${i+1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(list[i].title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        onTap: () => audioSfx.playAssetPath(list[i].audio),
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