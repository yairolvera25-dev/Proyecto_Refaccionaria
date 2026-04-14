import 'package:flutter/material.dart';

class AppTheme {
  // 1. Definimos los colores principales (Verde Refaccionaria)
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color darkBackground = Color(0xFF0F172A); // Un azul/negro muy elegante

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: darkBackground,
    
    // 2. Estilo de los textos
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    ),

    // 3. Estilo de los botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}