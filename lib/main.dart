import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

// ─── Cyber-Space Color Palette ───────────────────────────────────────────────
class CyberColors {
  CyberColors._();

  static const Color background    = Color(0xFF0A0E21);
  static const Color surface       = Color(0xFF1A1F38);
  static const Color surfaceLight  = Color(0xFF252A45);
  static const Color neonCyan      = Color(0xFF00E5FF);
  static const Color neonMagenta   = Color(0xFFFF00FF);
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color cardGlass     = Color(0x1AFFFFFF);   // 10% white
  static const Color borderGlass   = Color(0x33FFFFFF);   // 20% white
}

// ─── Theme Builder ───────────────────────────────────────────────────────────
ThemeData buildCyberTheme() {
  final baseTextTheme = GoogleFonts.orbitronTextTheme(
    ThemeData.dark().textTheme,
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CyberColors.background,
    primaryColor: CyberColors.neonCyan,
    colorScheme: const ColorScheme.dark(
      primary:   CyberColors.neonCyan,
      secondary: CyberColors.neonMagenta,
      surface:   CyberColors.surface,
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        color: CyberColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: CyberColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: CyberColors.textPrimary,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: CyberColors.textSecondary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: CyberColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.orbitron(
        color: CyberColors.neonCyan,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
      iconTheme: const IconThemeData(color: CyberColors.neonCyan),
    ),
    iconTheme: const IconThemeData(color: CyberColors.neonCyan),
    cardTheme: CardThemeData(
      color: CyberColors.cardGlass,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: CyberColors.borderGlass),
      ),
    ),
    dividerColor: CyberColors.borderGlass,
  );
}

// ─── App Entry ───────────────────────────────────────────────────────────────
void main() {
  runApp(
    const ProviderScope(
      child: WorldCup2026App(),
    ),
  );
}

class WorldCup2026App extends StatelessWidget {
  const WorldCup2026App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Cup 2026',
      debugShowCheckedModeBanner: false,
      theme: buildCyberTheme(),
      home: const OnboardingScreen(),
    );
  }
}

// ─── Temporary Main Screen ──────────────────────────────────────────────────
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CyberColors.background,
    );
  }
}
