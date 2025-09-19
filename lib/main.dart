import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Refolosim bara si background-ul
import 'ui/widgets/common_widgets.dart'; 
// Ecranul Animale (cu tab-uri + audio) – din patch-ul anterior
import 'ui/screens/animals_screen.dart';

void main() {
  runApp(const MuzicaMagicaApp());
}

class MuzicaMagicaApp extends StatelessWidget {
  const MuzicaMagicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muzica Magica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D8ECE)),
        useMaterial3: true,
      ),
      // Localizari corecte conform doc. oficial
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('ro'), // Română
        Locale('en'), // Engleză
      ],
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/animals': (_) => const AnimalsScreen(),
        // Hub-uri simple (placeholder) - functionale din prima
        '/games': (_) => const GamesHubScreen(),
        '/songs': (_) => const SongsHubScreen(),
        '/stories': (_) => const StoriesHubScreen(),
        // Rute utilitare
        '/xylophone': (_) => const SimplePlaceholder(title: 'Xilofon'),
        '/drums': (_) => const SimplePlaceholder(title: 'Tobe'),
        '/sounds': (_) => const SimplePlaceholder(title: 'Sunete'),
        '/parents': (_) => const SimplePlaceholder(title: 'Părinți'),
      },
    );
  }
}

/// ---- HOME ----
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_HomeItem>[
      _HomeItem('Animale', Icons.pets_rounded, '/animals'),
      _HomeItem('Jocuri', Icons.extension_rounded, '/games'),
      _HomeItem('Povești', Icons.menu_book_rounded, '/stories'),
      _HomeItem('Cântece', Icons.music_note_rounded, '/songs'),
    ];
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
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final cross = w > 1200 ? 6 : w > 900 ? 4 : w > 600 ? 3 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.05),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _HomeCard(item: items[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final IconData icon;
  final String route;
  _HomeItem(this.title, this.icon, this.route);
}

class _HomeCard extends StatelessWidget {
  final _HomeItem item;
  const _HomeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 48, color: Colors.white),
            const SizedBox(height: 10),
            Text(item.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/// ---- HUB PAGES (PLACEHOLDERS 100% FUNCTIONALE) ----
class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _HubScaffold(title: 'Jocuri');
  }
}
class SongsHubScreen extends StatelessWidget {
  const SongsHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _HubScaffold(title: 'Cântece');
  }
}
class StoriesHubScreen extends StatelessWidget {
  const StoriesHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _HubScaffold(title: 'Povești');
  }
}

class _HubScaffold extends StatelessWidget {
  final String title;
  const _HubScaffold({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              onXylophone: () => Navigator.pushNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushNamed(context, '/drums'),
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---- PLACEHOLDER SIMPLU (pt. rute utilitare) ----
class SimplePlaceholder extends StatelessWidget {
  final String title;
  const SimplePlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              onXylophone: () {},
              onDrums: () {},
              onSounds: () {},
              onParents: () {},
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}