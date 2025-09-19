import 'package:flutter/material.dart';
import '../theme.dart';

/// Draws the layered hills and leaves that form the decorative
/// background. This widget uses CustomPainter for performance
/// and control. Any child provided will be stacked above the
/// decorations.
class ForestBackground extends StatelessWidget {
  const ForestBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgSky, AppColors.bgHill, AppColors.bgGrass],
        ),
      ),
      child: Stack(
        children: [
          const _Hills(),
          const _Leaves(),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Paints two softly curved hills on the canvas to create depth.
class _Hills extends StatelessWidget {
  const _Hills();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HillPainter(),
      size: Size.infinite,
    );
  }
}

class _HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = AppColors.bgHill.withOpacity(.5);
    final paint2 = Paint()..color = AppColors.bgGrass.withOpacity(.55);

    // First hill.
    final hill1 = Path()
      ..moveTo(0, size.height * .65)
      ..quadraticBezierTo(size.width * .3, size.height * .55,
          size.width * .6, size.height * .68)
      ..quadraticBezierTo(size.width * .85, size.height * .78,
          size.width, size.height * .72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill1, paint1);

    // Second hill.
    final hill2 = Path()
      ..moveTo(0, size.height * .75)
      ..quadraticBezierTo(size.width * .25, size.height * .70,
          size.width * .5, size.height * .78)
      ..quadraticBezierTo(size.width * .8, size.height * .86,
          size.width, size.height * .82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Scatter leaves across the top of the screen as decorative accents.
class _Leaves extends StatelessWidget {
  const _Leaves();

  @override
  Widget build(BuildContext context) {
    // Generate leaves with slight variations in position and scale.
    final leaves = List<Widget>.generate(8, (i) {
      final color = i.isEven ? AppColors.leaf1 : AppColors.leaf2;
      final dx = 40.0 + i * 40.0;
      final dy = 40.0 + (i % 3) * 18.0;
      final scale = .8 + (i % 3) * .15;
      return _Leaf(color: color, dx: dx, dy: dy, scale: scale);
    });
    return IgnorePointer(child: Stack(children: leaves));
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.color, required this.dx, required this.dy, required this.scale});
  final Color color;
  final double dx, dy, scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Transform.scale(
        scale: scale,
        child: CustomPaint(
          painter: _LeafPainter(color),
          size: const Size(80, 36),
        ),
      ),
    );
  }
}

class _LeafPainter extends CustomPainter {
  final Color color;
  _LeafPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(30),
    );
    final fill = Paint()..color = color;
    canvas.drawRRect(rrect, fill);
    // Simple horizontal vein.
    final vein = Paint()
      ..color = Colors.white.withOpacity(.25)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        const Offset(10, 18), Offset(size.width - 10, 18), vein);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A ribbon bar used across screens for navigation and status. It
/// receives callbacks for each button so that screens can wire
/// navigation logic without tightly coupling to the widget.
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
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.85),
            borderRadius: BorderRadius.circular(Radii.xl),
            boxShadow: const [
              BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              _RoundIcon(
                icon: Icons.home_rounded,
                color: AppColors.orange,
                onTap: onHome,
                semantic: 'Acasă',
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundLabel(
                      label: 'P',
                      color: AppColors.yellow,
                      onTap: onXylophone,
                      semantic: 'Pian/Xilofon',
                    ),
                    const SizedBox(width: 10),
                    _RoundLabel(
                      label: 'D',
                      color: AppColors.green,
                      onTap: onDrums,
                      semantic: 'Tobe',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _RoundIcon(
                icon: Icons.music_note_rounded,
                color: AppColors.purple,
                onTap: onSounds,
                semantic: 'Sunete',
              ),
              if (onParents != null) ...[
                const SizedBox(width: 10),
                _RoundIcon(
                  icon: Icons.settings,
                  color: AppColors.panel,
                  onTap: onParents!,
                  semantic: 'Părinți',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.semantic,
  });
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String semantic;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semantic,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Center(),
          ),
        ),
      ),
    );
  }
}

class _RoundLabel extends StatelessWidget {
  const _RoundLabel({
    required this.label,
    required this.color,
    required this.onTap,
    required this.semantic,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String semantic;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semantic,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a row of five stars representing a progress metric. The
/// number of filled stars is passed via [filled]. Unfilled stars
/// are semi‑transparent. Animation scales the star when filled.
class StarRow extends StatelessWidget {
  const StarRow({super.key, this.filled = 0});
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(5, (i) {
        final isOn = i < filled;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedScale(
            scale: isOn ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Icon(
              Icons.grade_rounded,
              size: 32,
              color: isOn ? AppColors.yellow : Colors.white.withOpacity(.7),
              shadows: const [
                Shadow(blurRadius: 6, color: Colors.black26),
              ],
            ),
          ),
        );
      }),
    );
  }
}