import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';
import '../../../services/audio_manager.dart';

class NumbersScreen extends StatelessWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final numbers = List<int>.generate(10, (i) => i + 1);
    final noteFiles = [
      'C.wav','D.wav','E.wav','F.wav','G.wav','A.wav','B.wav','C2.wav','D.wav','E.wav'
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
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
              const Text('Numere', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    for (var i=0; i<numbers.length; i++)
                      _NumberCard(
                        number: numbers[i],
                        onTap: () async {
                          await audioManager.play('assets/audio/notes/'+noteFiles[i]);
                        },
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
}

class _NumberCard extends StatefulWidget {
  final int number;
  final VoidCallback onTap;
  const _NumberCard({required this.number, required this.onTap});

  @override
  State<_NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<_NumberCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.95).animate(_controller);

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _handleTap,
          child: Center(
            child: Text(
              widget.number.toString(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
