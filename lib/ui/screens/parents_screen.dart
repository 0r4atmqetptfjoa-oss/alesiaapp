import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';

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
  // In a real app, store hashed PIN in secure storage or DB.
  static const _storedPin = '1234';

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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        ListTile(
          leading: const Icon(Icons.volume_up),
          title: const Text('Volum instrumente'),
          trailing: Slider(
            min: 0,
            max: 1,
            divisions: 10,
            value: 0.8,
            onChanged: (v) {
              // TODO: persist volume
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.ads_click),
          title: const Text('Elimină reclamele'),
          subtitle: const Text('Cumpără versiunea fără reclame'),
          onTap: () {
            // TODO: trigger in_app_purchase
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Pachete de conținut'),
          subtitle: const Text('Vizualizează și gestionează pack-urile instalate'),
          onTap: () {
            // Navigate to the content packs manager screen when tapped.
            Navigator.pushNamed(context, '/content_packs');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Schimbă PIN'),
          onTap: () {
            // TODO: implement PIN change
          },
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