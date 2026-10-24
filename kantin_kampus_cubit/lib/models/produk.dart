import 'package:flutter/foundation.dart';

@immutable
class Produk {
  const Produk({
    required this.nama,
    required this.harga,
    required this.ikon,
  });

  final String nama;
  final int harga;
  final String ikon;
}

class ItemKeranjang {
  const ItemKeranjang({required this.produk, this.jumlah = 1});

  final Produk produk;
  final int jumlah;
}