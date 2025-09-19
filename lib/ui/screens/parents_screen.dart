import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/ads_service.dart';
import '../../services/iap_service.dart';

/// Parent screen protected by a PIN gate. Once the correct PIN is
/// entered, settings and administrative options are displayed.
class ParentsScreen extends StatefulWidget {
  const ParentsScreen({super.key});

  @override
  State<ParentsScreen> createState() => _ParentsScreenState();
}

class _ParentsScreenState extends State<ParentsScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _unlocked = false;
  String _error = '';
  bool _purchaseInProgress = false;
  bool _highContrast = false;
  double _textScale = 1.0;

  // In a real app, store hashed PIN in secure storage or DB.
  static const _storedPin = '1234';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ForestBackground(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: _textScale),
          child: Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                primary: _highContrast ? Colors.black : theme.colorScheme.primary,
                secondary: _highContrast ? Colors.black : theme.colorScheme.secondary,
              ),
              textTheme: _highContrast
                  ? theme.textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black)
                  : theme.textTheme,
            ),
            child: Column(
              children: [
                RibbonBar(
                  onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                  onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
                  onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
                  onSounds: () => Navigator.pushNamed(context, '/sounds'),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: _unlocked ? _buildSettings() : _buildGate(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGate() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Secțiune pentru părinți',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md)),
              labelText: 'Introduceți PIN (1234)',
              errorText: _error.isEmpty ? null : _error,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (_pinController.text == _storedPin) {
                setState(() {
                  _unlocked = true;
                  _error = '';
                });
              } else {
                setState(() {
                  _error = 'PIN incorect';
                  _pinController.clear();
                });
              }
            },
            child: const Text('Accesează'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    final isPro = adsService.proEntitlement || iapService.proEntitlement;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        // Accessibility toggles
        ListTile(
          leading: const Icon(Icons.contrast),
          title: const Text('Contrast mare'),
          trailing: Switch(
            value: _highContrast,
            onChanged: (v) => setState(() => _highContrast = v),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: const Text('Mărire text'),
          subtitle: Text('${(_textScale * 100).round()}%'),
          trailing: SizedBox(
            width: 180,
            child: Slider(
              min: 0.9,
              max: 1.4,
              divisions: 5,
              value: _textScale,
              onChanged: (v) => setState(() => _textScale = v),
            ),
          ),
        ),
        const Divider(),

        // Ads status
        ListTile(
          leading: Icon(isPro ? Icons.verified : Icons.ads_click),
          title: Text(isPro ? 'Reclame dezactivate' : 'Reclame active'),
          subtitle: Text(isPro
              ? 'Mulțumim! Pachetul fără reclame este activ.'
              : (adsService.adGraceConsumed
                  ? 'Perioada de grație s-a terminat.'
                  : 'Perioadă de grație: ${(adsService.adGraceRemainingMs / 60000).ceil()} min rămas.')),
        ),
        const Divider(),

        // Purchase button
        ListTile(
          leading: const Icon(Icons.shopping_bag_outlined),
          title: const Text('Elimină reclamele'),
          subtitle: Text(kIsWeb
              ? 'Achizițiile nu sunt disponibile pe web. Testează pe Android/iOS.'
              : 'Cumpără versiunea fără reclame (non-consumabil)'),
          onTap: isPro || _purchaseInProgress
              ? null
              : () async {
                  setState(() => _purchaseInProgress = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pornesc achiziția…')),
                  );
                  final ok = await iapService.purchaseRemoveAds();
                  if (ok) {
                    adsService.proEntitlement = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Achiziție reușită. Reclamele au fost dezactivate.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Achiziție anulată sau eșuată.')),
                    );
                  }
                  setState(() => _purchaseInProgress = false);
                },
          trailing: isPro
              ? const Icon(Icons.verified, color: Colors.green)
              : (_purchaseInProgress ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()) : null),
        ),
        const Divider(),

        // Content packs
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Pachete de conținut'),
          subtitle: const Text('Vizualizează și gestionează pack-urile instalate'),
          onTap: () => Navigator.pushNamed(context, '/content_packs'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Despre aplicație'),
          subtitle: const Text('Versiunea 1.0.0'),
        ),
      ],
    );
  }
}