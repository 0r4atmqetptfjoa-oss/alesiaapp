import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

/// Model representing a simple children’s song. Each song consists of a
/// title, a sequence of note names (C, D, E, F, G, A, B, C2, etc.) and a
/// corresponding list of lyric lines. When the song is played the notes
/// and lyrics will be highlighted in sync. The notes should map to
/// existing audio files under assets/audio/instruments.
class Song {
  final String title;
  final List<String> notes;
  final List<String> lyrics;

  const Song({required this.title, required this.notes, required this.lyrics});
}

/// A screen that displays a list of simple songs for children to listen
/// to and follow along. Songs are organised in tabs; tapping the play
/// button will iterate through the note sequence and play each note
/// using the [audioManager]. As the song progresses the current
/// lyric line is highlighted so children can follow along like a
/// karaoke. Songs are designed to be short and repetitive to suit
/// toddlers’ attention spans.
class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Define a couple of demo songs. Additional songs can be added
  // easily by extending this list. The notes correspond to the
  // filenames in assets/audio/instruments (e.g. C.wav, D.wav). The
  // lyrics are split into lines which will be highlighted as the
  // song plays.
  final List<Song> _songs = const [
    Song(
      title: 'Oac Oac',
      notes: [
        'C', 'C', 'G', 'G', 'A', 'A', 'G', // Oac, oac, oac, oac
        'F', 'F', 'E', 'E', 'D', 'D', 'C', // continuă
      ],
      lyrics: [
        'Oac, oac, oac, oac',
        'Oac, oac, oac, oac',
        'Cântă broscuța, în lacul plin',
        'Oac, oac, oac, oac',
      ],
    ),
    Song(
      title: 'Do Re Mi',
      notes: [
        'C', 'D', 'E', 'F', 'G', 'A', 'B', 'C2',
      ],
      lyrics: [
        'Do, re, mi, fa',
        'Sol, la, si, do',
      ],
    ),
  ];

  // Index of the currently highlighted lyric line. A value of -1
  // indicates that no line is currently highlighted (song is
  // stopped). This index is updated as the song plays.
  int _highlightIndex = -1;

  // Indicates whether a song is currently playing. Used to disable
  // repeated taps on the play button.
  bool _isPlaying = false;

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

  /// Plays the selected song by iterating through its notes. For
  /// simplicity, each note is assumed to last the same amount of time
  /// (600ms). As each note is played, the corresponding lyric line is
  /// highlighted. When the song finishes the highlight resets.
  Future<void> _playSong(Song song) async {
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _highlightIndex = 0;
    });
    final int totalLines = song.lyrics.length;
    final int notesPerLine = (song.notes.length / totalLines).ceil();
    for (int i = 0; i < song.notes.length; i++) {
      final note = song.notes[i];
      // Determine which line to highlight based on the index of the note.
      final lineIndex = (i / notesPerLine).floor();
      if (lineIndex != _highlightIndex) {
        setState(() {
          _highlightIndex = lineIndex;
        });
      }
      await audioManager.play('assets/audio/instruments/$note.wav');
      // Wait a bit before playing the next note. Adjust this value to
      // control tempo; shorter durations will play the song faster.
      await Future.delayed(const Duration(milliseconds: 600));
    }
    // Reset state after completion.
    setState(() {
      _highlightIndex = -1;
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            // Ribbon bar provides navigation to other modules and parents section.
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylo: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            // Tab bar for each song.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                  borderRadius: BorderRadius.circular(Radii.xl),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                      offset: Offset(0, 6),
                    ),
                  ],
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              song.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            // Song content area.
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_songs.length, (index) {
                  final song = _songs[index];
                  final isCurrentTab = index == _tabController.index;
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Lyrics display. Each line is highlighted when
                        // playing. If no line is highlighted the default
                        // colour is used.
                        Expanded(
                          child: ListView.builder(
                            itemCount: song.lyrics.length,
                            itemBuilder: (context, lineIndex) {
                              final bool isHighlighted =
                                  _highlightIndex == lineIndex && isCurrentTab;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: isHighlighted
                                                ? AppColors.orange
                                                : AppColors.textDark,
                                            fontWeight: isHighlighted
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ) ??
                                      TextStyle(
                                        color: isHighlighted
                                            ? AppColors.orange
                                            : AppColors.textDark,
                                      ),
                                  child: Center(child: Text(song.lyrics[lineIndex])),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Play button. Disabled when already playing.
                        SizedBox(
                          width: 200,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Radii.lg),
                              ),
                            ),
                            onPressed: _isPlaying
                                ? null
                                : () => _playSong(song),
                            child: Text(
                              _isPlaying ? 'Se redă...' : 'Redă melodia',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
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