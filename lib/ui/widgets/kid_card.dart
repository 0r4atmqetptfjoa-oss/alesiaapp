import 'package:flutter/material.dart';
import '../theme.dart';
import 'animated_hover_scale.dart';

class KidCard extends StatelessWidget {
  const KidCard({
    super.key,
    required this.title,
    required this.imageAsset,
    this.badgeText,
    this.onTap,
  });

  final String title;
  final String imageAsset;
  final String? badgeText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverScale(
      onTap: onTap,
      child: Material(
        color: Colors.white,
        elevation: 6,
        borderRadius: BorderRadius.circular(Radii.lg),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bgHill.withOpacity(.5),
                        AppColors.bgGrass.withOpacity(.6),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: AppColors.leaf2.withOpacity(.9),
                  ),
                ),
              ),
            ),
            if (badgeText != null)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.white.withOpacity(.85),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}