import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/produk.dart';

class KeranjangCubit extends Cubit<List<ItemKeranjang>> {
  KeranjangCubit() : super([]);

  void tambah(Produk produk) {
    final daftar = List<ItemKeranjang>.from(state);
    final indeks = daftar.indexWhere((item) => item.produk.nama == produk.nama);

    if (indeks == -1) {
      daftar.add(ItemKeranjang(produk: produk));
    } else {
      daftar[indeks] = ItemKeranjang(
        produk: produk,
        jumlah: daftar[indeks].jumlah + 1,
      );
    }

    emit(daftar);
  }

  void kurangi(Produk produk) {
    final daftar = List<ItemKeranjang>.from(state);
    final indeks = daftar.indexWhere((item) => item.produk.nama == produk.nama);
    if (indeks == -1) return;

    if (daftar[indeks].jumlah == 1) {
      daftar.removeAt(indeks);
    } else {
      daftar[indeks] = ItemKeranjang(
        produk: produk,
        jumlah: daftar[indeks].jumlah - 1,
      );
    }

    emit(daftar);
  }

  void kosongkan() {
    emit([]);
  }
}