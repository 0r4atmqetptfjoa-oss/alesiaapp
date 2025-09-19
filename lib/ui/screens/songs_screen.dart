import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../data/content_repository.dart';
import '../../services/audio_manager.dart';
import '../widgets/common_widgets.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  List<Song> _songs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await contentRepo.loadSongs();
    setState(() {
      _songs = s;
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
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _songs.isEmpty
                    ? _fallback()
                    : _grid(),
          ),
        ],
      ),
    );
  }

  Widget _grid() {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: _songs.length,
      itemBuilder: (_, i) {
        final s = _songs[i];
        return _SongTile(song: s);
      },
    );
  }

  // Keep original behavior if JSON missing
  Widget _fallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Nu am găsit assets/content/songs.json — folosesc conținutul existent din aplicație.',
          textAlign: TextAlign.center),
      ),
    );
  }
}

class _SongTile extends StatelessWidget {
  const _SongTile({required this.song});
  final Song song;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _playDemo(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.title, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(song.language.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }

  void _playDemo(BuildContext context) async {
    // quick demo: play first few notes if available (expects assets/instruments... in your project)
    for (final n in song.notes.take(6)) {
      final asset = _noteToAsset(n);
      if (asset != null) await audioManager.play(asset);
      await Future.delayed(const Duration(milliseconds: 220));
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Redare demo: ${song.title}')));
    }
  }

  String? _noteToAsset(String note) {
    // Map simple notes to your existing assets naming, adjust as needed.
    final m = {
      'C4':'assets/audio/instruments/C.wav',
      'D4':'assets/audio/instruments/D.wav',
      'E4':'assets/audio/instruments/E.wav',
      'F4':'assets/audio/instruments/F.wav',
      'G4':'assets/audio/instruments/G.wav',
      'A4':'assets/audio/instruments/A.wav',
      'B4':'assets/audio/instruments/B.wav',
      'C5':'assets/audio/instruments/C5.wav',
      'G3':'assets/audio/instruments/G3.wav',
    };
    return m[note];
  }
}