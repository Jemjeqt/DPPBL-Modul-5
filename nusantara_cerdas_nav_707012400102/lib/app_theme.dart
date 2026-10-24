import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primer = Color(0xFF0F6656);
  static const Color aksen = Color(0xFFDA9A34);
  static const Color latar = Color(0xFFF5F6F4);
  static const Color permukaan = Color(0xFFFFFFFF);
  static const Color garis = Color(0xFFE1E4E1);
  static const Color tekstUtama = Color(0xFF1B231F);
  static const Color tekstSekunder = Color(0xFF5B655F);

  /// Label kecil kapital di atas judul section (gaya editorial).
  static const TextStyle gayaEyebrow = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: tekstSekunder,
  );

  static ThemeData get tema {
    final skemaWarna = ColorScheme.fromSeed(
      seedColor: primer,
      brightness: Brightness.light,
    ).copyWith(primary: primer, secondary: aksen, surface: permukaan);

    return ThemeData(
      useMaterial3: true,
      colorScheme: skemaWarna,
      scaffoldBackgroundColor: latar,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.15,
          color: tekstUtama,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: tekstUtama,
        ),
        titleMedium: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: tekstUtama,
        ),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: tekstUtama),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          height: 1.45,
          color: tekstSekunder,
        ),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: latar,
        foregroundColor: tekstUtama,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: tekstSekunder,
        ),
      ),
      cardTheme: CardThemeData(
        color: permukaan,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: garis),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: garis,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: tekstUtama,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: tekstUtama,
        ),
        subtitleTextStyle: TextStyle(fontSize: 13, color: tekstSekunder),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: tekstUtama,
        unselectedLabelColor: tekstSekunder,
        labelStyle: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: primer,
        dividerColor: garis,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: permukaan,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final aktif = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: aktif ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.2,
            color: aktif ? tekstUtama : tekstSekunder,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final aktif = states.contains(WidgetState.selected);
          return IconThemeData(color: aktif ? primer : tekstSekunder);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: permukaan,
        selectedIconTheme: const IconThemeData(color: primer),
        unselectedIconTheme: const IconThemeData(color: tekstSekunder),
        selectedLabelTextStyle: const TextStyle(
          color: tekstUtama,
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: tekstSekunder,
          fontSize: 13,
        ),
        indicatorColor: Colors.transparent,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: permukaan),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tekstUtama,
          foregroundColor: permukaan,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tekstUtama,
          side: const BorderSide(color: garis),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primer,
        foregroundColor: permukaan,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tekstUtama,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
