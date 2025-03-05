import 'package:flutter/material.dart';

class AppTheme {
  // Renk paleti
  static const Color primaryColor = Color(0xFFFF9B66); // #AD9AC9 - turuncu yine
  static const Color secondaryColor = Color(0xFF97C1A9); // Pastel yeşil
  static const Color accentColor = Color(0xFFFF777B); // #FF777B - Pembe
  static const Color tertiaryColor = Color(0xFFFF9B66); // #FF9B66 - Turuncu
  static const Color quaternaryColor = Color(0xFFFFCF69); // #FFCF69 - Sarı

  // Tema verileri
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: tertiaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: primaryColor,
      ),
    );
  }

  // Drawer tema renkleri
  static Color getDrawerItemColor(bool isSelected) {
    return isSelected ? secondaryColor : Colors.grey.shade600;
  }

  // Drawer arka plan rengi
  static Color get drawerHeaderColor => primaryColor;

  // Drawer başlık metni rengi
  static Color get drawerHeaderTextColor => Colors.white;

  // Kütüphane marker rengi
  static Color get libraryMarkerColor => accentColor;

  // Kullanıcı konum marker rengi
  static Color get userLocationMarkerColor => secondaryColor;

  // Kart arka plan rengi
  static Color get cardBackgroundColor => Colors.grey.shade50;
}
