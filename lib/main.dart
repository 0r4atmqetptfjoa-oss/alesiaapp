import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/screens/home_screen.dart';
import 'ui/screens/animals_screen.dart';
import 'ui/screens/songs_screen.dart';
import 'ui/screens/games_screen.dart';
import 'ui/screens/stories_screen.dart';

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
      // ✅ localizări oficiale
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('ro'), Locale('en')],
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/animals': (_) => const AnimalsScreen(),
        '/songs': (_) => const SongsScreen(),
        '/games': (_) => const GamesScreen(),
        '/stories': (_) => const StoriesScreen(),
        // utilitare/placeholder
        '/parents': (_) => const PlaceholderScaffold(title: 'Părinți (WIP)'),
        '/xylophone': (_) => const PlaceholderScaffold(title: 'Xilofon (WIP)'),
        '/drums': (_) => const PlaceholderScaffold(title: 'Tobe (WIP)'),
        '/sounds': (_) => const AnimalsScreen(),
      },
    );
  }
}

class PlaceholderScaffold extends StatelessWidget {
  final String title;
  const PlaceholderScaffold({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('În curând...')),
    );
  }
}