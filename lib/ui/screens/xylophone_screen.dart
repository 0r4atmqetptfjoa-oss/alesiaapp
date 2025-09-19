import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_KeySpec> keys = [
      _KeySpec('C', AppColors.red),
      _KeySpec('D', AppColors.orange),
      _KeySpec('E', AppColors.yellow),
      _KeySpec('F', AppColors.green),
      _KeySpec('G', AppColors.teal),
      _KeySpec('A', AppColors.blue),
      _KeySpec('B', AppColors.indigo),
      _KeySpec('C2', AppColors.purple),
    ];

    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () {},
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final barWidth = isWide ? 90.0 : constraints.maxWidth / 9;
                  final barSpacing = 10.0;
                  return Center(
                    child: Wrap(
                      spacing: barSpacing,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: List.generate(keys.length, (i) {
                        final spec = keys[i];
                        // Stagger heights for a classic xylophone look
                        final baseHeight = isWide ? 280.0 : 200.0;
                        final height = baseHeight + (i * 10);
                        return _XyloKey(
                          note: spec.note,
                          color: spec.color,
                          width: barWidth,
                          height: height,
                        );
                      }),
                    ),
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

class _KeySpec {
  final String note;
  final Color color;
  _KeySpec(this.note, this.color);
}

class _XyloKey extends StatefulWidget {
  const _XyloKey({required this.note, required this.color, required this.width, required this.height});
  final String note;
  final Color color;
  final double width;
  final double height;

  @override
  State<_XyloKey> createState() => _XyloKeyState();
}

class _XyloKeyState extends State<_XyloKey> with SingleTickerProviderStateMixin {
  double _press = 0.0;

  Future<void> _play() async {
    setState(() => _press = 1.0);
    await audioManager.play('assets/audio/instruments/${widget.note}.wav');
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) setState(() => _press = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final double elevation = 10 + 10 * (1 - _press);
    final double scaleY = 1 - 0.02 * _press;
    final double translateY = 4 * _press;

    return GestureDetector(
      onTap: _play,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.identity()
          ..translate(0.0, translateY)
          ..scale(1.0, scaleY),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(Radii.lg),
          boxShadow: [
            BoxShadow(
              blurRadius: elevation,
              spreadRadius: 1,
              color: Colors.black.withOpacity(.25),
              offset: Offset(0, elevation / 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.note,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}