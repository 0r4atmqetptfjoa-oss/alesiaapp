import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/ads_service.dart';

/// The home screen acts as the main menu for the app. From here
/// users can access instruments, songs (placeholder), and sounds.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper function to navigate after showing an ad if needed.
    Future<void> _navigateWithAd(String route) async {
      if (adsService.shouldShowAd()) {
        await adsService.showInterstitial();
      }
      if (route == '/') {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } else {
        Navigator.pushNamed(context, route);
      }
    }
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () {},
              onXylophone: () => Navigator.pushNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushNamed(context, '/drums'),
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 20,
                spacing: 20,
                children: [
                  _BigButton(
                    color: AppColors.panel,
                    label: 'Instrumente',
                    onTap: () => _navigateWithAd('/xylophone'),
                  ),
                  _BigButton(
                    color: AppColors.teal,
                    label: 'Sunete',
                    onTap: () => _navigateWithAd('/sounds'),
                  ),
                  _BigButton(
                    color: AppColors.green,
                    label: 'Animale',
                    onTap: () => _navigateWithAd('/animals'),
                  ),
                  _BigButton(
                    color: AppColors.blue,
                    label: 'Jocuri',
                    onTap: () => _navigateWithAd('/games'),
                  ),
                  _BigButton(
                    color: AppColors.orange,
                    label: 'Povești',
                    onTap: () => _navigateWithAd('/stories'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// A large square button used in the home screen. The button
/// expands equally in width and height, with a label centered.
class _BigButton extends StatelessWidget {
  const _BigButton({
    required this.color,
    required this.label,
    required this.onTap,
  });
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(Radii.xl),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.xl),
        onTap: onTap,
        child: Container(
          width: 240,
          height: 120,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
    );
  }
}