import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';

/// A simple memory matching game. Flip two cards to reveal their
/// icons; if they match they stay revealed. When all pairs are
/// matched the game resets.
class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  late List<_CardItem> cards;
  _CardItem? firstFlipped;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.pets,
      Icons.music_note,
    ];
    final items = <_CardItem>[];
    int id = 0;
    for (var icon in icons) {
      // Create two of each
      items.add(_CardItem(id++, icon));
      items.add(_CardItem(id++, icon));
    }
    items.shuffle(Random());
    setState(() {
      cards = items;
      firstFlipped = null;
      waiting = false;
    });
  }

  void _onCardTap(_CardItem card) {
    if (waiting || card.isRevealed || card.isMatched) return;
    setState(() => card.isRevealed = true);
    if (firstFlipped == null) {
      firstFlipped = card;
    } else {
      // second card flipped
      waiting = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            if (card.icon == firstFlipped!.icon) {
              card.isMatched = true;
              firstFlipped!.isMatched = true;
            } else {
              card.isRevealed = false;
              firstFlipped!.isRevealed = false;
            }
            firstFlipped = null;
            waiting = false;
            // Check end
            if (cards.every((c) => c.isMatched)) {
              // Delay reset
              Future.delayed(const Duration(seconds: 1), () => _reset());
            }
          });
        }
      });
    }
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
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text('Memory', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _MemoryCard(
                      card: card,
                      onTap: () => _onCardTap(card),
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

class _CardItem {
  final int id;
  final IconData icon;
  bool isRevealed = false;
  bool isMatched = false;
  _CardItem(this.id, this.icon);
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.card, required this.onTap});
  final _CardItem card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final reveal = card.isRevealed || card.isMatched;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: reveal ? AppColors.teal : Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(Radii.lg),
          boxShadow: const [
            BoxShadow(blurRadius: 6, color: Colors.black26),
          ],
        ),
        child: Center(
          child: reveal
              ? Icon(card.icon, color: AppColors.textDark, size: 32)
              : const Icon(Icons.help_outline, color: Colors.black45, size: 32),
        ),
      ),
    );
  }
}