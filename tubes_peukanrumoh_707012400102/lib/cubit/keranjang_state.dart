import 'package:equatable/equatable.dart';

import '../halaman/data/data_contoh.dart';

class KeranjangState extends Equatable {
  const KeranjangState({
    this.items = const {},
    this.totalBarang = 0,
    this.totalHarga = 0,
    this.ongkir = 0,
  });

  final Map<int, ItemKeranjang> items;
  final int totalBarang;
  final int totalHarga;
  final int ongkir;

  int get totalBayar => totalHarga + ongkir;

  bool get kosong => items.isEmpty;

  List<ItemKeranjang> get item => List.unmodifiable(items.values);

  int jumlahUntuk(ProdukContoh produk) => items[produk.id]?.jumlah ?? 0;

  KeranjangState copyWith({
    Map<int, ItemKeranjang>? items,
    int? totalBarang,
    int? totalHarga,
    int? ongkir,
  }) {
    return KeranjangState(
      items: items ?? this.items,
      totalBarang: totalBarang ?? this.totalBarang,
      totalHarga: totalHarga ?? this.totalHarga,
      ongkir: ongkir ?? this.ongkir,
    );
  }

  @override
  List<Object?> get props => [items, totalBarang, totalHarga, ongkir];
}
