import 'dart:async';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

class Song {
  final String title;
  final List<String> notes;
  final List<String> lyrics;
  const Song({required this.title, required this.notes, required this.lyrics});
}

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Song> _songs = const [
    Song(
      title: 'Oac Oac',
      notes: ['C','C','G','G','A','A','G','F','F','E','E','D','D','C'],
      lyrics: ['Oac, oac, oac, oac','Oac, oac, oac, oac','Cântă broscuța, în lacul plin','Oac, oac, oac, oac'],
    ),
    Song(
      title: 'Do Re Mi',
      notes: ['C','D','E','F','G','A','B','C2'],
      lyrics: ['Do, re, mi, fa','Sol, la, si, do'],
    ),
  ];

  int _highlightIndex = -1;
  bool _isPlaying = false;
  bool _paused = false;
  bool _cancelled = false;
  double _msPerNote = 600;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _songs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _playSong(Song song) async {
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _paused = false;
      _cancelled = false;
      _highlightIndex = 0;
    });
    final int totalLines = song.lyrics.length;
    final int notesPerLine = (song.notes.length / totalLines).ceil();
    for (int i = 0; i < song.notes.length; i++) {
      if (_cancelled) break;
      while (_paused && !_cancelled) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (_cancelled) break;

      final note = song.notes[i];
      final lineIndex = (i / notesPerLine).floor();
      if (lineIndex != _highlightIndex) {
        setState(() => _highlightIndex = lineIndex);
      }
      await audioManager.play('assets/audio/instruments/$note.wav');
      final delay = Duration(milliseconds: _msPerNote.round());
      final steps = 6;
      for (int s = 0; s < steps; s++) {
        if (_paused || _cancelled) break;
        await Future.delayed(delay ~/ steps);
      }
    }
    setState(() {
      _highlightIndex = -1;
      _isPlaying = false;
      _paused = false;
      _cancelled = false;
    });
  }

  void _pauseOrResume() {
    if (!_isPlaying) return;
    setState(() => _paused = !_paused);
  }

  void _stop() {
    if (!_isPlaying) return;
    setState(() {
      _cancelled = true;
      _paused = false;
      _isPlaying = false;
      _highlightIndex = -1;
    });
  }

  double _progressFor(Song song) {
    // Approximate progress using highlighted line
    if (!_isPlaying || _highlightIndex < 0) return 0;
    final total = song.lyrics.length;
    return ((_highlightIndex + 1) / total).clamp(0, 1);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                  borderRadius: BorderRadius.circular(Radii.xl),
                  boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 6))],
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.textDark,
                  unselectedLabelColor: AppColors.textDark.withOpacity(0.5),
                  indicator: BoxDecoration(
                    color: AppColors.leaf1.withOpacity(.4),
                    borderRadius: BorderRadius.circular(Radii.xl),
                  ),
                  tabs: _songs
                      .map((song) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              song.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_songs.length, (index) {
                  final song = _songs[index];
                  final isCurrent = index == _tabController.index;
                  final progress = _progressFor(song);
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Controls row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Play'),
                              onPressed: _isPlaying ? null : () => _playSong(song),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: Icon(_paused ? Icons.play_circle_rounded : Icons.pause_rounded),
                              label: Text(_paused ? 'Resume' : 'Pause'),
                              onPressed: _isPlaying ? _pauseOrResume : null,
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.stop_rounded),
                              label: const Text('Stop'),
                              onPressed: _isPlaying ? _stop : null,
                            ),
                            const SizedBox(width: 16),
                            // Tempo slider
                            Row(
                              children: [
                                const Icon(Icons.speed_rounded),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 220,
                                  child: Slider(
                                    min: 300,
                                    max: 900,
                                    divisions: 12,
                                    value: _msPerNote,
                                    label: '${(_msPerNote).round()} ms/n',
                                    onChanged: (v) => setState(() => _msPerNote = v),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Progress bar
                        SizedBox(
                          width: 480,
                          child: LinearProgressIndicator(
                            value: isCurrent ? progress : 0,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Lyrics list
                        Expanded(
                          child: ListView.builder(
                            itemCount: song.lyrics.length,
                            itemBuilder: (context, lineIndex) {
                              final bool isHighlighted = _highlightIndex == lineIndex && isCurrent;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: isHighlighted ? AppColors.orange : AppColors.textDark,
                                        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                      ) ?? TextStyle(
                                        color: isHighlighted ? AppColors.orange : AppColors.textDark,
                                      ),
                                  child: Center(child: Text(song.lyrics[lineIndex])),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}