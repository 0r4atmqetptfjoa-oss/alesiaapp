import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

/// Simple data holder pairing a drum pad colour with its audio file name.
class _PadSpec {
  final Color color;
  final String audioName;
  const _PadSpec(this.color, this.audioName);
}

/// A screen featuring a simple drum kit. Each pad animates on tap.
class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of drum pads with their colour and a corresponding
    // audio file. We reuse the instrument note samples for the demo.
    final pads = [
      _PadSpec(AppColors.yellow, 'C.wav'),
      _PadSpec(AppColors.blue, 'D.wav'),
      _PadSpec(AppColors.orange, 'E.wav'),
      _PadSpec(AppColors.green, 'F.wav'),
      _PadSpec(AppColors.purple, 'G.wav'),
      _PadSpec(AppColors.red, 'A.wav'),
    ];
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () {},
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: pads
                      .map((spec) => _DrumPad(color: spec.color, audioName: spec.audioName))
                      .toList(),
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

/// Each drum pad is a concentric stack of circles. On tap it shrinks
/// slightly for tactile feedback. Audio playback can be added later.
class _DrumPad extends StatefulWidget {
  const _DrumPad({required this.color, required this.audioName});
  final Color color;
  final String audioName;

  @override
  State<_DrumPad> createState() => _DrumPadState();
}

class _DrumPadState extends State<_DrumPad>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) async {
        await _controller.reverse();
        // Play the associated drum sound using the global audio manager.
        final path = 'assets/audio/instruments/${widget.audioName}';
        await audioManager.play(path);
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: .92).animate(_controller),
        child: Container(
          width: 150,
          height: 150,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _ring(widget.color.withOpacity(.90), 150),
              _ring(Colors.white.withOpacity(.85), 128),
              _ring(widget.color.withOpacity(.85), 108),
              _ring(Colors.white.withOpacity(.9), 88),
              Icon(
                Icons.star,
                color: Colors.white.withOpacity(.9),
                size: 42,
                shadows: const [
                  Shadow(blurRadius: 8, color: Colors.black26),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ring(Color c, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 4)),
          ],
        ),
      );
}