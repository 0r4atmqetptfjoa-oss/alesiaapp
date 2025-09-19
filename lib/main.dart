import 'package:flutter/material.dart';

import 'ui/theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/xylophone_screen.dart';
import 'ui/screens/drums_screen.dart';
import 'ui/screens/sounds_screen.dart';
import 'ui/screens/animals_screen.dart';
import 'ui/screens/games/puzzle_screen.dart';
import 'ui/screens/games/memory_screen.dart';
import 'ui/screens/games/games_home_screen.dart';
import 'ui/screens/story_screen.dart';
import 'ui/screens/parents_screen.dart';
import 'ui/screens/games/alphabet_screen.dart';
import 'ui/screens/songs_screen.dart';
import 'ui/screens/content_packs_screen.dart';
import 'ui/screens/games/numbers_screen.dart';
import 'services/ads_service.dart';

/// Entry point of the Muzica Magica app. This sets up a basic
/// MaterialApp with a custom theme and a simple named route
/// configuration. When running on a device, the debug banner is
/// removed. Each route points to a top‑level screen defined in
/// `lib/ui/screens`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuzicaMagicaApp());
}

/// The root widget for the application. It configures the theme
/// and the routing table. Additional dependencies (state
/// management, database, etc.) can be injected here when
/// expanding the app beyond the UI prototype.
class MuzicaMagicaApp extends StatefulWidget {
  const MuzicaMagicaApp({super.key});

  @override
  State<MuzicaMagicaApp> createState() => _MuzicaMagicaAppState();
}

class _MuzicaMagicaAppState extends State<MuzicaMagicaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Start the ad grace session on launch.
    adsService.startSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    adsService.endSession();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      adsService.endSession();
    } else if (state == AppLifecycleState.resumed) {
      adsService.startSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muzica Magica',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Named routes for navigation. Additional screens can be
      // added here as the app expands.
      routes: {
        '/': (_) => const HomeScreen(),
        '/xylophone': (_) => const XylophoneScreen(),
        '/drums': (_) => const DrumsScreen(),
        '/sounds': (_) => const SoundsScreen(),
        '/animals': (_) => const AnimalsScreen(),
        '/puzzle': (_) => const PuzzleScreen(),
        '/memory': (_) => const MemoryScreen(),
        '/stories': (_) => const StoryScreen(),
        '/parents': (_) => const ParentsScreen(),
        '/games': (_) => const GamesHomeScreen(),
        '/alphabet': (_) => const AlphabetScreen(),
        '/songs': (_) => const SongsScreen(),
        '/content_packs': (_) => const ContentPacksScreen(),
        '/numbers': (_) => NumbersScreen(),
      },
    );
  }
}