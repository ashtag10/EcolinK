import 'package:flutter/material.dart';

/// Couleurs principales issues de la maquette Figma Ecolink.
abstract final class AppColors {
  static const vertEcolink = Color(0xFF31A05E);      // Vert principal (#31A05E)
  static const noir = Color(0xFF000000);             // Noir
  static const blanc = Color(0xFFFFFFFF);            // Blanc
  static const grisFonce = Color(0xFF2C2C2C);        // Gris foncé
  static const violet = Color(0xFF270AAA);           // Violet
  static const grisClair = Color(0xFF898989);        // Gris clair

  // Exemples de transparence (si besoin)
  static const blancTransparent = Color(0x4DFFFFFF); // Blanc 30% opacité
  static const noirTransparent = Color(0x4D000000);  // Noir 30% opacité

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: vertEcolink,
    onPrimary: blanc,
    secondary: violet,
    onSecondary: blanc,
    surface: blanc,
    onSurface: noir,
    error: Colors.red,
    onError: blanc,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: vertEcolink,
    onPrimary: noir,
    secondary: violet,
    onSecondary: blanc,
    surface: grisFonce,
    onSurface: blanc,
    error: Colors.red,
    onError: noir,
  );
}