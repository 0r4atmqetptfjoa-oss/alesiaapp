import 'dart:async';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> with TickerProviderStateMixin {
  final songs = const [
    _Song(
      title: 'Oac Oac',
      lines: [
        _SongLine(['C','C','D','E'], 'Oac, oac, oac pe lac'),
        _SongLine(['E','D','C','D'], 'Sar brotacul mic si tac'),
      ],
    ),
    _Song(
      title: 'Do Re Mi',
      lines: [
        _SongLine(['C','D','E','F','G','A','B','C2'], 'Do re mi fa sol la si do'),
      ],
    ),
  ];

  int _tab = 0;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = songs[_tab];
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RibbonBar(
                onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
                onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
                onSounds: () => Navigator.pushNamed(context, '/sounds'),
                onParents: () => Navigator.pushNamed(context, '/parents'),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('Cântece', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _tab,
                      onChanged: (v) => setState(()=> _tab = v ?? 0),
                      items: [
                        for (var i=0; i<songs.length; i++)
                          DropdownMenuItem(value: i, child: Text(songs[i].title)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isPlaying ? null : _playSong,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Redă'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final line in song.lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(line.lyrics, style: const TextStyle(fontSize: 18)),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playSong() async {
    setState(()=> _isPlaying = true);
    final song = songs[_tab];
    for (final line in song.lines) {
      for (final note in line.notes) {
        await audioManager.play('assets/audio/notes/'+_noteToFile(note));
        await Future.delayed(const Duration(milliseconds: 250));
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setState(()=> _isPlaying = false);
  }

  String _noteToFile(String n) => switch (n) {
    'C' => 'C.wav',
    'D' => 'D.wav',
    'E' => 'E.wav',
    'F' => 'F.wav',
    'G' => 'G.wav',
    'A' => 'A.wav',
    'B' => 'B.wav',
    'C2' => 'C2.wav',
    _ => 'C.wav',
  };
}

class _Song {
  final String title;
  final List<_SongLine> lines;
  const _Song({required this.title, required this.lines});
}

class _SongLine {
  final List<String> notes;
  final String lyrics;
  const _SongLine(this.notes, this.lyrics);
}
