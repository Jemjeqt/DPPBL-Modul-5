import 'package:flutter/material.dart';

import '../halaman/data/data_contoh.dart';
import '../halaman/detail_pesanan.dart';
import '../halaman/detail_produk.dart';
import '../halaman/halaman_bayar.dart';
import '../halaman/halaman_keranjang.dart';
import '../halaman/halaman_tentang.dart';
import '../halaman/halaman_tidak_ditemukan.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  AppRoutes._();

  static const String beranda = '/';
  static const String produk = '/produk';
  static const String keranjang = '/keranjang';
  static const String bayar = '/bayar';
  static const String detailPesanan = '/detail-pesanan';
  static const String tentang = '/tentang';
  static const String tidakDitemukan = '/tidak-ditemukan';
}

class ArgumenProduk {
  const ArgumenProduk({required this.produk});

  final ProdukContoh produk;
}

class ArgumenBayar {
  const ArgumenBayar({required this.item});

  final List<ItemKeranjang> item;

  int get totalHarga => item.fold(0, (total, item) => total + item.subtotal);

  int get ongkir => item.isEmpty ? 0 : 12000;

  int get total => totalHarga + ongkir;
}

class AppRoutesHelper {
  AppRoutesHelper._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.beranda:
        return _halaman(settings, const KerangkaUtama());

      case AppRoutes.produk:
        final args = settings.arguments;
        if (args is ArgumenProduk) {
          return _halaman(settings, DetailProduk(produk: args.produk));
        }
        return null;

      case AppRoutes.keranjang:
        return _halaman(settings, const HalamanKeranjang());

      case AppRoutes.bayar:
        final args = settings.arguments;
        if (args is ArgumenBayar) {
          return _halaman(settings, HalamanBayar(argumen: args));
        }
        return null;

      case AppRoutes.detailPesanan:
        final args = settings.arguments;
        if (args is PesananContoh) {
          return _halaman(settings, DetailPesanan(pesanan: args));
        }
        return null;

      case AppRoutes.tentang:
        return _halaman(settings, const HalamanTentang());

      case AppRoutes.tidakDitemukan:
        return _halaman(settings, const HalamanTidakDitemukan());

      default:
        return null;
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => HalamanTidakDitemukan(namaRoute: settings.name),
    );
  }

  static MaterialPageRoute<T> _halaman<T>(RouteSettings settings, Widget page) {
    return MaterialPageRoute<T>(settings: settings, builder: (_) => page);
  }
}
