import 'package:flutter/material.dart';
import '../theme.dart';

class ForestBackground extends StatelessWidget {
  const ForestBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.bgGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            left: -60, bottom: -40, right: -60, height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.bgHill,
                borderRadius: BorderRadius.circular(160),
              ),
            ),
          ),
          Positioned(
            left: -40, bottom: -60, right: -40, height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.bgGrass,
                borderRadius: BorderRadius.circular(140),
              ),
            ),
          ),
          Positioned(top: 30, left: 24, child: _Leaf(color: AppColors.leaf1)),
          Positioned(top: 80, right: 24, child: _Leaf(color: AppColors.leaf2)),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: .2,
      child: Container(
        width: 28, height: 18,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
      ),
    );
  }
}

class RibbonBar extends StatelessWidget {
  const RibbonBar({
    super.key,
    required this.onHome,
    required this.onXylophone,
    required this.onDrums,
    required this.onSounds,
    this.onParents,
  });

  final VoidCallback onHome;
  final VoidCallback onXylophone;
  final VoidCallback onDrums;
  final VoidCallback onSounds;
  final VoidCallback? onParents;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool showLabels = width >= 700;
    final canPop = Navigator.of(context).canPop();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.88),
          borderRadius: BorderRadius.circular(Radii.xl),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 6))],
        ),
        child: Row(
          children: [
            if (canPop)
              _NavButton(
                icon: Icons.arrow_back_rounded,
                label: 'Înapoi',
                tooltip: 'Înapoi',
                onTap: () => Navigator.of(context).maybePop(),
                showLabel: showLabels,
              ),
            _NavButton(
              icon: Icons.home_rounded,
              label: 'Acasă',
              tooltip: 'Mergi la ecranul principal',
              onTap: onHome,
              showLabel: showLabels,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NavButton(
                    icon: Icons.music_note_rounded,
                    label: 'Xilofon',
                    tooltip: 'Deschide Xilofon',
                    onTap: onXylophone,
                    showLabel: showLabels,
                  ),
                  const SizedBox(width: 8),
                  _NavButton(
                    icon: Icons.album_rounded,
                    label: 'Tobe',
                    tooltip: 'Deschide Tobe',
                    onTap: onDrums,
                    showLabel: showLabels,
                  ),
                  const SizedBox(width: 8),
                  _NavButton(
                    icon: Icons.graphic_eq_rounded,
                    label: 'Sunete',
                    tooltip: 'Deschide Sunete',
                    onTap: onSounds,
                    showLabel: showLabels,
                  ),
                ],
              ),
            ),
            if (onParents != null) ...[
              const SizedBox(width: 12),
              _NavButton(
                icon: Icons.parental_controls_rounded,
                label: 'Părinți',
                tooltip: 'Acces părinți (PIN)',
                onTap: onParents!,
                showLabel: showLabels,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
    required this.showLabel,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Icon(icon, color: AppColors.textDark),
      ),
    );

    final content = showLabel
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          )
        : iconWidget;

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 250),
      showDuration: const Duration(seconds: 4),
      verticalOffset: 10,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: content,
        ),
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow({super.key, this.total = 3, this.filled = 0});
  final int total;
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final on = i < filled;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(on ? Icons.star_rounded : Icons.star_border_rounded, color: on ? Colors.amber : Colors.black26),
        );
      }),
    );
  }
}