import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A centralized palette for the primary colours and common
/// measurements used throughout the application. Keeping colours
/// and spacing in one place makes it easier to tweak the look
/// and feel without hunting through multiple files.
class AppColors {
  // Background gradients: sky, hills and grass. These soft
  // pastels evoke a friendly nature scene seen in the original
  // concept illustrations provided by the user.
  static const bgSky = Color(0xFFE7F9FF);
  static const bgHill = Color(0xFFD7F1E1);
  static const bgGrass = Color(0xFFC6EDC8);

  /// New unified gradient background combining sky, hill, and grass.
  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      bgSky,
      bgHill,
      bgGrass,
    ],
  );

  // Vibrant rainbow colours used for instruments and buttons.
  static const red = Color(0xFFFF6B6B);
  static const orange = Color(0xFFFFA94D);
  static const yellow = Color(0xFFFFE66D);
  static const green = Color(0xFF6EE7B7);
  static const teal = Color(0xFF5BD5D8);
  static const blue = Color(0xFF60A5FA);
  static const indigo = Color(0xFF7C83FD);
  static const purple = Color(0xFFD08CFF);

  // Leaves for decorative foreground details.
  static const leaf1 = Color(0xFF7AC77A);
  static const leaf2 = Color(0xFF4FBF73);

  // Panels and highlight surfaces.
  static const panel = Color(0xFFFFD37A);
  static const panelDark = Color(0xFFE2A83F);

  // Primary text colour.
  static const textDark = Color(0xFF2B2B2B);
}

/// Handy constants for spacing and radii. These values can be
/// fine-tuned to achieve the right rhythm and softness in the UI.
class Gaps {
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class Radii {
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Builds the base theme used by the app. It applies our custom
/// colour palette and sets a friendly rounded font. If desired,
/// you can extend this with dark mode or further customisations.
ThemeData buildAppTheme() {
  final textTheme = GoogleFonts.baloo2TextTheme().apply(
    displayColor: AppColors.textDark,
    bodyColor: AppColors.textDark,
  );

  return ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.bgSky,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      primary: AppColors.green,
      secondary: AppColors.yellow,
      surface: Colors.white,
      background: AppColors.bgSky,
    ),
    // Use default splash behaviour. InkSparkle is not available on all platforms.
    // splashFactory: InkSparkle.constantTurbulenceSeedSparkle,
  );
}
