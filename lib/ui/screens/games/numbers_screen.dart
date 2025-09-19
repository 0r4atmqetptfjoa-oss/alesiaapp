import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';
import '../../../services/audio_manager.dart';

/// Displays a grid of numbers and plays a corresponding sound when a
/// number is tapped. Each number is mapped to one of the musical
/// notes available in the instruments folder. This teaches children
/// to recognise numbers while associating them with tones.
class NumbersScreen extends StatelessWidget {
  NumbersScreen({super.key});

  // List of numbers to display. We go from 1 to 10 to keep the
  // interface simple and manageable for preschool children.
  final List<int> numbers = List<int>.generate(10, (index) => index + 1);

  // Map each number to a note name. The notes are repeated after 7
  // since we only have C, D, E, F, G, A, B, C2 available. This
  // simple mapping associates numbers with different pitches.
  final List<String> notesMapping = [
    'C', 'D', 'E', 'F', 'G', 'A', 'B', 'C2', 'D', 'E'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylo: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text(
              'Numere',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    final number = numbers[index];
                    final note = notesMapping[index % notesMapping.length];
                    final Color tileColor = _pickColor(index);
                    return _NumberTile(
                      number: number,
                      color: tileColor,
                      note: note,
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

  /// Picks a colour for each tile based on its index to achieve a
  /// rainbow-like distribution across the grid. Uses the defined
  /// AppColors for consistency with other screens.
  Color _pickColor(int index) {
    switch (index % 7) {
      case 0:
        return AppColors.red;
      case 1:
        return AppColors.orange;
      case 2:
        return AppColors.yellow;
      case 3:
        return AppColors.green;
      case 4:
        return AppColors.teal;
      case 5:
        return AppColors.blue;
      case 6:
        return AppColors.indigo;
      default:
        return AppColors.purple;
    }
  }
}

/// A single tile representing a number. When tapped the tile scales
/// slightly to provide visual feedback and plays the associated note.
class _NumberTile extends StatefulWidget {
  const _NumberTile({required this.number, required this.color, required this.note});
  final int number;
  final Color color;
  final String note;

  @override
  State<_NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<_NumberTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _controller.forward();
    await audioManager.play('assets/audio/instruments/${widget.note}.wav');
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 - _controller.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(Radii.lg),
            boxShadow: const [
              BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 4)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.number.toString(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
    );
  }
}