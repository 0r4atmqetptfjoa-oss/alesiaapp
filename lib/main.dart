import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n/app_localizations.dart';
import 'ui/theme.dart';
import 'ui/screens/splash_screen.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuzicaMagicaApp());
}

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
      initialRoute: '/splash',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        '/splash': (_) => const SplashScreen(),
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