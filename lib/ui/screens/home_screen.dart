import 'dart:async';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/ads_service.dart';
import '../../services/iap_service.dart';

/// The home screen acts as the main menu for the app. From here
/// users can access instruments, sounds, animals, games, stories and songs.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            // Main content
            Column(
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
                      _BigButton(
                        color: AppColors.purple,
                        label: 'Cântece',
                        onTap: () => _navigateWithAd('/songs'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),

            // Top-right status chip (Pro / Ads)
            const Positioned(
              top: 10,
              right: 12,
              child: _ProStatusChip(),
            ),
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

/// Small pill-shaped chip that shows monetization status:
/// - "Pro activ" when IAP entitlement is present
/// - "Reclame active" (sau "Grație activă") în rest
/// Tapping the chip opens the Parents screen to manage purchases.
class _ProStatusChip extends StatefulWidget {
  const _ProStatusChip();

  @override
  State<_ProStatusChip> createState() => _ProStatusChipState();
}

class _ProStatusChipState extends State<_ProStatusChip> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    // Periodic refresh so status updates after returning from Parents.
    _tick = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPro = adsService.proEntitlement || iapService.proEntitlement;
    final bool graceConsumed = adsService.adGraceConsumed;
    final minutesLeft = (adsService.adGraceRemainingMs / 60000).ceil();

    final Color bg = isPro ? Colors.green : Colors.black87;
    final IconData icon = isPro ? Icons.verified : (graceConsumed ? Icons.ads_click : Icons.timelapse);
    final String text = isPro
        ? 'Pro activ • Fără reclame'
        : (graceConsumed ? 'Reclame active' : 'Grație activă: ~${minutesLeft}m');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => Navigator.pushNamed(context, '/parents'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}