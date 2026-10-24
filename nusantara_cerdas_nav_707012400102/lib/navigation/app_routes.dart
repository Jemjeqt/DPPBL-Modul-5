import 'package:flutter/material.dart';
import '../data/data_layanan.dart';
import '../pages/halaman_formulir_laporan.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_rincian_layanan.dart';
import '../pages/halaman_riwayat_laporan.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  AppRoutes._();

  static const String beranda = '/';
  static const String daftarLayanan = '/daftar-layanan';
  static const String rincianLayanan = '/rincian-layanan';
  static const String riwayatLaporan = '/riwayat-laporan';
  static const String formulirLaporan = '/formulir-laporan';
  static const String halamanLayanan = '/halaman-layanan';

  /// Route tanpa argumen didaftarkan di sini.
  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      daftarLayanan: (context) => const HalamanLayananRoute(),
      riwayatLaporan: (context) => const HalamanRiwayatLaporan(),
      formulirLaporan: (context) => const HalamanFormulirLaporan(),
    };
  }

  /// Route yang memerlukan argumen dibentuk secara dinamis di sini.
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == rincianLayanan) {
      final layanan = settings.arguments as LayananPublik;
      return MaterialPageRoute(
        builder: (context) => HalamanRincianLayanan(layanan: layanan),
      );
    }
    return null;
  }

  /// Dipakai ketika nama route tidak terdaftar sama sekali.
  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 56, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Route "${settings.name}" belum terdaftar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
