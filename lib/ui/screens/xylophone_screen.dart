import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

/// A screen displaying a colourful xylophone. Each bar can be
/// tapped to animate and (in a later iteration) play a sound. The
/// height of bars alternates slightly to mimic a real instrument.
class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the xylophone bars with their labels and colours.
    final bars = [
      _BarSpec('C', AppColors.red, 'C.wav'),
      _BarSpec('D', AppColors.orange, 'D.wav'),
      _BarSpec('E', AppColors.yellow, 'E.wav'),
      _BarSpec('F', AppColors.green, 'F.wav'),
      _BarSpec('G', AppColors.teal, 'G.wav'),
      _BarSpec('A', AppColors.blue, 'A.wav'),
      _BarSpec('B', AppColors.indigo, 'B.wav'),
      _BarSpec('C', AppColors.purple, 'C2.wav'),
    ];
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () {},
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            // Star row is placeholder for future progress tracking.
            const StarRow(filled: 3),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth - 40;
                    final barWidth = (totalWidth / bars.length).clamp(64.0, 120.0);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < bars.length; i++)
                          _XyloBar(
                            spec: bars[i],
                            width: barWidth,
                            height: 240 + (i % 2 == 0 ? 0 : 24),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Internal data holder for a xylophone bar: its label (note), colour and
/// the corresponding audio file name. Using an explicit audio name
/// allows the last C note to map to C2.wav.
class _BarSpec {
  final String label;
  final Color color;
  final String audioName;
  _BarSpec(this.label, this.color, this.audioName);
}

/// Widget representing a single bar of the xylophone. On tap, the
/// bar scales slightly to provide visual feedback. Audio playback
/// would be triggered in a future integration with an audio player.
class _XyloBar extends StatefulWidget {
  const _XyloBar({required this.spec, required this.width, required this.height});
  final _BarSpec spec;
  final double width;
  final double height;

  @override
  State<_XyloBar> createState() => _XyloBarState();
}

class _XyloBarState extends State<_XyloBar>
    with SingleTickerProviderStateMixin {
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

  Future<void> _handleTap() async {
    // Animate the bar down and back up
    await _controller.forward();
    await _controller.reverse();
    // Play the associated note using the global audio manager. We build
    // the asset path using the audioName defined in the BarSpec. The
    // audio files are located under assets/audio/instruments/.
    final path = 'assets/audio/instruments/${widget.spec.audioName}';
    await audioManager.play(path);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _handleTap(),
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: .96).animate(_controller),
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: widget.spec.color,
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: const [
                BoxShadow(blurRadius: 10, offset: Offset(0, 8), color: Colors.black26),
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(.15),
                  Colors.black.withOpacity(.08),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 16,
                  child: _rivet(),
                ),
                Positioned(
                  bottom: 16,
                  child: _rivet(),
                ),
                Text(
                  widget.spec.label,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white.withOpacity(.9),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rivet() => Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.85),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(blurRadius: 6, color: Colors.black26),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.06),
            shape: BoxShape.circle,
          ),
        ),
      );
}