import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Which visual theme to build via [buildAppTheme].
///
/// - [warm]: expenseful's original brand identity (paper background,
///   coral/marigold/teal/grape/sky/pink categories, Baloo 2 + Plus Jakarta
///   Sans + Space Grotesk). This is the default and what ships in v1.
/// - [altDark] / [altLight]: an alternate high-contrast palette (cyan/
///   purple/yellow on near-black, and blue/gray on off-white) using Space
///   Grotesk + Inter + JetBrains Mono. Kept alongside the warm theme as
///   candidate variants — not wired up as user-selectable yet.
enum AppThemeVariant { warm, altDark, altLight }

/// Centralized design tokens for expenseful.
///
/// Every screen should pull colors, text styles, and spacing from here —
/// never hardcode a hex value or font size directly in a widget.
/// This keeps the visual language consistent as the app grows and makes
/// future re-theming (e.g. dark mode, Material You overrides) a single
/// point of change.
class AppColors {
  AppColors._();

  // Base palette
  static const Color paperBackground = Color(0xFFFBF3E7);
  static const Color plumInk = Color(0xFF2D1B2E);

  // Category colors — used for category chips, coin jar segments, charts
  static const Color coral = Color(0xFFFF6F59);
  static const Color marigold = Color(0xFFFFB627);
  static const Color teal = Color(0xFF2A9D8F);
  static const Color grape = Color(0xFF6A4C93);
  static const Color sky = Color(0xFF4CC9F0);
  static const Color pink = Color(0xFFFF8FA3);

  static const List<Color> categoryPalette = [
    coral,
    marigold,
    teal,
    grape,
    sky,
    pink,
  ];

  // Semantic
  static const Color success = teal;
  static const Color warning = marigold;
  static const Color danger = coral;

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3E7D8);
}

/// Alt-dark palette — cyan/purple/yellow on near-black.
///
/// Hex values taken directly from the reference board. Background/surface
/// tones were not labeled on the board, so they're approximated from the
/// screenshot and safe to adjust once you have exact values.
class AppColorsAltDark {
  AppColorsAltDark._();

  static const Color primary = Color(0xFF00F0FF);
  static const Color secondary = Color(0xFF7000FF);
  static const Color tertiary = Color(0xFFFED639);
  static const Color neutral = Color(0xFF707979);

  static const Color background = Color(0xFF121616);
  static const Color surface = Color(0xFF1B2020);
  static const Color onBackground = Color(0xFFEAF2F2);
  static const Color onSurfaceMuted = Color(0xFFA9B4B4);
}

/// Alt-light palette — blue/gray on off-white/lavender.
///
/// Same caveat as [AppColorsAltDark]: background/surface tones are
/// approximated from the screenshot, not explicitly labeled.
class AppColorsAltLight {
  AppColorsAltLight._();

  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF5B6475);
  static const Color tertiary = Color(0xFFF7F9FC);
  static const Color neutral = Color(0xFF0B1220);

  static const Color background = Color(0xFFDCE1F0);
  static const Color surface = Color(0xFFEEF1FA);
  static const Color onBackground = Color(0xFF0B1220);
  static const Color onSurfaceMuted = Color(0xFF5B6475);
}

/// Text styles for the warm theme, built via GoogleFonts — no manual font
/// files needed, fetched from fonts.google.com and cached after first load.
/// See docs/FONTS.md for the production/offline-bundling tradeoff.
class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.baloo2(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.plumInk,
      );

  static TextStyle get displayMedium => GoogleFonts.baloo2(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.plumInk,
      );

  static TextStyle get bodyRegular => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.plumInk,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.plumInk,
      );

  static TextStyle get numericLarge => GoogleFonts.spaceGrotesk(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.plumInk,
      );

  static TextStyle get numericMedium => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.plumInk,
      );
}

/// Font family notes for the alt theme variants (altDark / altLight):
/// Space Grotesk (headline), Inter (body), JetBrains Mono (labels) — all
/// applied via GoogleFonts directly in the theme builders below.
///
/// Reference board shows "Body: Geist" on the dark variant and
/// "Body: Inter" on the light variant. Treating that as an inconsistency
/// in the source board rather than an intentional per-mode choice — using
/// Inter for body text on both, so the two variants read as one coherent
/// typographic system rather than diverging by theme. Swap
/// `GoogleFonts.inter(...)` for `GoogleFonts.geist(...)` in
/// [_buildAltDarkTheme] if that split was actually intentional.

/// Spacing scale — use instead of magic numbers for padding/margins.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadii {
  AppRadii._();

  static const double sheet = 28; // bottom sheet top corners
  static const double card = 20;
  static const double chip = 999; // pill shape
}

/// Builds the app's ThemeData for the given [variant].
///
/// Defaults to [AppThemeVariant.warm] — expenseful's shipping v1 identity —
/// so existing call sites (`buildAppTheme()`) keep working unchanged.
///
/// Material You dynamic color can be layered in later via
/// [DynamicColorBuilder] — when that's wired up, treat the dynamic
/// ColorScheme as tinting accents only, and keep the warm variant's
/// background/text identity fixed so the app doesn't lose its brand look
/// on every device.
ThemeData buildAppTheme([AppThemeVariant variant = AppThemeVariant.warm]) {
  switch (variant) {
    case AppThemeVariant.warm:
      return _buildWarmTheme();
    case AppThemeVariant.altDark:
      return _buildAltDarkTheme();
    case AppThemeVariant.altLight:
      return _buildAltLightTheme();
  }
}

ThemeData _buildWarmTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.paperBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.grape,
      brightness: Brightness.light,
      surface: AppColors.surface,
    ),
  );

  final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme.copyWith(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      bodyLarge: AppTypography.bodyRegular,
      bodyMedium: AppTypography.bodyMedium,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    ),
  );
}

ThemeData _buildAltDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsAltDark.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsAltDark.primary,
      brightness: Brightness.dark,
      primary: AppColorsAltDark.primary,
      secondary: AppColorsAltDark.secondary,
      tertiary: AppColorsAltDark.tertiary,
      surface: AppColorsAltDark.surface,
      onSurface: AppColorsAltDark.onBackground,
    ),
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColorsAltDark.onBackground,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColorsAltDark.onBackground,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: AppColorsAltDark.onBackground,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: AppColorsAltDark.onSurfaceMuted,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        color: AppColorsAltDark.onBackground,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsAltDark.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsAltDark.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    ),
  );
}

ThemeData _buildAltLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsAltLight.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsAltLight.primary,
      brightness: Brightness.light,
      primary: AppColorsAltLight.primary,
      secondary: AppColorsAltLight.secondary,
      surface: AppColorsAltLight.surface,
      onSurface: AppColorsAltLight.onBackground,
    ),
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColorsAltLight.onBackground,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColorsAltLight.onBackground,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: AppColorsAltLight.onBackground,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: AppColorsAltLight.onSurfaceMuted,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        color: AppColorsAltLight.onBackground,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsAltLight.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsAltLight.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    ),
  );
}