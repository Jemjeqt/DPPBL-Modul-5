import 'package:flutter/material.dart';

// Pengaturan tema demo (terang/gelap) yang dipakai bersama.
// Disimpan di memori saja: demo navigasi ini tidak butuh persistensi,
// dan kedua mode wajib dites berfungsi (aturan R-34 di antislop).
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void setDark(bool value) {
    if (_mode == (value ? ThemeMode.dark : ThemeMode.light)) return;
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
