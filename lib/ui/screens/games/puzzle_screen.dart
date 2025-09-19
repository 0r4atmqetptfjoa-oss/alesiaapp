import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';

/// A simple 2x2 sliding puzzle game. The goal is to drag each
/// scrambled piece to its correct location. When all four tiles
/// match their targets, a congratulatory message appears. The
/// puzzle uses a single image asset split virtually into four
/// quadrants.
class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  // Map from target index (0-3) to piece index assigned to it, or null.
  late Map<int, int?> assignments;

  @override
  void initState() {
    super.initState();
    _randomize();
  }

  void _randomize() {
    final rand = Random();
    final pieces = List<int>.generate(4, (i) => i);
    pieces.shuffle(rand);
    assignments = {for (var i = 0; i < 4; i++) i: pieces[i]};
    setState(() {});
  }

  bool get isSolved => assignments.entries.every((e) => e.value == e.key);

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
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text('Puzzle', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildPuzzleGrid(context),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _randomize,
              child: const Text('Shuffle'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final tileSize = size.width / 2;
        return Stack(
          children: [
            // Drop targets
            for (var targetIndex = 0; targetIndex < 4; targetIndex++)
              Positioned(
                left: (targetIndex % 2) * tileSize,
                top: (targetIndex ~/ 2) * tileSize,
                width: tileSize,
                height: tileSize,
                child: DragTarget<int>(
                  onWillAccept: (piece) => true,
                  onAccept: (piece) {
                    setState(() {
                      // Swap positions: find current assignment and swap
                      final otherTarget = assignments.entries
                          .firstWhere((e) => e.value == targetIndex)
                          .key;
                      assignments[otherTarget] = assignments[targetIndex];
                      assignments[targetIndex] = piece;
                    });
                  },
                  builder: (context, candidate, rejected) {
                    final assignedPiece = assignments[targetIndex];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.white.withOpacity(.2),
                      ),
                      child: assignedPiece != null
                          ? _buildPuzzlePiece(assignedPiece)
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            // Draggable pieces (floating)
            for (var entry in assignments.entries)
              if (entry.value != null && entry.key != entry.value)
                Positioned(
                  left: (entry.value! % 2) * tileSize,
                  top: (entry.value! ~/ 2) * tileSize,
                  width: tileSize,
                  height: tileSize,
                  child: Draggable<int>(
                    data: entry.key,
                    feedback: SizedBox(
                      width: tileSize,
                      height: tileSize,
                      child: _buildPuzzlePiece(entry.key),
                    ),
                    childWhenDragging: const SizedBox.shrink(),
                    child: _buildPuzzlePiece(entry.value!),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _buildPuzzlePiece(int index) {
    // Map index to alignment positions for cropping
    final alignments = [
      const Alignment(-1, -1),
      const Alignment(1, -1),
      const Alignment(-1, 1),
      const Alignment(1, 1),
    ];
    return ClipRect(
      child: Align(
        alignment: alignments[index],
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Image.asset('assets/images/puzzle.png', fit: BoxFit.cover),
      ),
    );
  }
}