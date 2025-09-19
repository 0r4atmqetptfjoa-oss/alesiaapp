import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('ro'),
    Locale('en'),
  ];

  static final Map<String, Map<String, String>> _vals = {
    'ro': {
      'home_instruments': 'Instrumente',
      'home_sounds': 'Sunete',
      'home_animals': 'Animale',
      'home_games': 'Jocuri',
      'home_stories': 'Povești',
      'home_songs': 'Cântece',
      'parents': 'Părinți',
    },
    'en': {
      'home_instruments': 'Instruments',
      'home_sounds': 'Sounds',
      'home_animals': 'Animals',
      'home_games': 'Games',
      'home_stories': 'Stories',
      'home_songs': 'Songs',
      'parents': 'Parents',
    },
  };

  String t(String key) {
    final lang = _vals[locale.languageCode] ?? _vals['ro']!;
    return lang[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ro', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}