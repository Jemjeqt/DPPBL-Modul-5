import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/favorit_cubit.dart';
import 'cubit/keranjang_cubit.dart';
import 'halaman/widget_desain.dart';
import 'navigation/app_routes.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const PeukanRumohApp());
}

class PeukanRumohApp extends StatelessWidget {
  const PeukanRumohApp({super.key});

  static const Color seedTeal = Color(0xFF11998E);

  static ThemeData _bangunTema(Brightness kecerahan) {
    final skema = ColorScheme.fromSeed(
      seedColor: seedTeal,
      brightness: kecerahan,
    );
    final gelap = kecerahan == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: skema,
      scaffoldBackgroundColor:
          gelap ? const Color(0xFF0E1413) : const Color(0xFFF6FAF9),
      appBarTheme: AppBarTheme(
        backgroundColor: skema.surface,
        foregroundColor: skema.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: skema.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: skema.surface,
        hintStyle: TextStyle(color: skema.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Warna.tealTua,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: skema.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Warna.teal.withValues(alpha: gelap ? 0.30 : 0.14),
        height: 66,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KeranjangCubit>(create: (_) => KeranjangCubit()),
        BlocProvider<FavoritCubit>(create: (_) => FavoritCubit()),
      ],
      child: ListenableBuilder(
        listenable: ThemeController.instance,
        builder: (context, _) {
          return MaterialApp(
            title: 'Peukan Rumoh',
            debugShowCheckedModeBanner: false,
            theme: _bangunTema(Brightness.light),
            darkTheme: _bangunTema(Brightness.dark),
            themeMode: ThemeController.instance.mode,
            initialRoute: AppRoutes.beranda,
            onGenerateRoute: AppRoutesHelper.onGenerateRoute,
            onUnknownRoute: AppRoutesHelper.onUnknownRoute,
          );
        },
      ),
    );
  }
}
