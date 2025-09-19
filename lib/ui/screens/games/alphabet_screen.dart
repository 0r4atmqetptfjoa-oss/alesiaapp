import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';
import '../../../services/audio_manager.dart';

/// A simple interactive alphabet screen. Displays 26 cards, one for
/// each letter. Tapping a card plays an associated sound. For
/// demonstration we reuse instrument note samples for letters.
class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate the list of letters A–Z.
    final letters = List.generate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i));
    // Map each letter to an audio file (cycled through available notes).
    final noteFiles = [
      'C.wav',
      'D.wav',
      'E.wav',
      'F.wav',
      'G.wav',
      'A.wav',
      'B.wav',
      'C2.wav',
    ];
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text(
              'Alfabet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final letter = letters[index];
                    final audioName = noteFiles[index % noteFiles.length];
                    return _AlphabetCard(
                      letter: letter,
                      audioName: audioName,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AlphabetCard extends StatefulWidget {
  const _AlphabetCard({required this.letter, required this.audioName});
  final String letter;
  final String audioName;

  @override
  State<_AlphabetCard> createState() => _AlphabetCardState();
}

class _AlphabetCardState extends State<_AlphabetCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    final path = 'assets/audio/instruments/${widget.audioName}';
    await audioManager.play(path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _onTap(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: .95).animate(_controller),
        child: Material(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(Radii.lg),
          elevation: 6,
          child: Center(
            child: Text(
              widget.letter,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}