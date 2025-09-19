import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';

/// A placeholder screen for managing downloadable content packs. In a
/// real implementation this would read from a database and allow
/// downloading new packs from the network. Here we simulate a few
/// packs with enable/disable toggles.
class ContentPacksScreen extends StatefulWidget {
  const ContentPacksScreen({super.key});

  @override
  State<ContentPacksScreen> createState() => _ContentPacksScreenState();
}

class _ContentPacksScreenState extends State<ContentPacksScreen> {
  // Simulated list of content packs. Each has a name and an enabled flag.
  final List<_PackItem> _packs = [
    _PackItem('Animale - Junglă', true),
    _PackItem('Povești de iarnă', false),
    _PackItem('Instrumente exotice', true),
  ];

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
            Text(
              'Pachete de conținut',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _packs.length,
                itemBuilder: (context, index) {
                  final pack = _packs[index];
                  return SwitchListTile(
                    tileColor: Colors.white.withOpacity(.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                    title: Text(pack.name),
                    value: pack.enabled,
                    onChanged: (val) {
                      setState(() {
                        pack.enabled = val;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PackItem {
  final String name;
  bool enabled;
  _PackItem(this.name, this.enabled);
}