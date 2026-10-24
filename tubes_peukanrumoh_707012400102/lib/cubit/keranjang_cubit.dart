import 'package:flutter_bloc/flutter_bloc.dart';

import '../halaman/data/data_contoh.dart';
import 'keranjang_state.dart';

class KeranjangCubit extends Cubit<KeranjangState> {
  KeranjangCubit() : super(const KeranjangState());

  void tambah(ProdukContoh produk) {
    final sekarang = state.jumlahUntuk(produk);
    final itemBaru = ItemKeranjang(produk: produk, jumlah: sekarang + 1);
    final itemsBaru = Map<int, ItemKeranjang>.from(state.items)..[produk.id] = itemBaru;

    final totalBarang = itemsBaru.values.fold(0, (t, i) => t + i.jumlah);
    final totalHarga = itemsBaru.values.fold(0, (t, i) => t + i.subtotal);
    final ongkir = totalBarang == 0 ? 0 : 12000;

    emit(KeranjangState(
      items: itemsBaru,
      totalBarang: totalBarang,
      totalHarga: totalHarga,
      ongkir: ongkir,
    ));
  }

  void kurangi(ProdukContoh produk) {
    final sekarang = state.jumlahUntuk(produk);
    final itemsBaru = Map<int, ItemKeranjang>.from(state.items);

    if (sekarang <= 1) {
      itemsBaru.remove(produk.id);
    } else {
      itemsBaru[produk.id] = ItemKeranjang(produk: produk, jumlah: sekarang - 1);
    }

    final totalBarang = itemsBaru.values.fold(0, (t, i) => t + i.jumlah);
    final totalHarga = itemsBaru.values.fold(0, (t, i) => t + i.subtotal);
    final ongkir = totalBarang == 0 ? 0 : 12000;

    emit(KeranjangState(
      items: itemsBaru,
      totalBarang: totalBarang,
      totalHarga: totalHarga,
      ongkir: ongkir,
    ));
  }

  void hapus(int idProduk) {
    final itemsBaru = Map<int, ItemKeranjang>.from(state.items)..remove(idProduk);

    final totalBarang = itemsBaru.values.fold(0, (t, i) => t + i.jumlah);
    final totalHarga = itemsBaru.values.fold(0, (t, i) => t + i.subtotal);
    final ongkir = totalBarang == 0 ? 0 : 12000;

    emit(KeranjangState(
      items: itemsBaru,
      totalBarang: totalBarang,
      totalHarga: totalHarga,
      ongkir: ongkir,
    ));
  }

  void kosongkan() {
    emit(const KeranjangState());
  }

  void ubahJumlah(ProdukContoh produk, int jumlahBaru) {
    final itemsBaru = Map<int, ItemKeranjang>.from(state.items);

    if (jumlahBaru <= 0) {
      itemsBaru.remove(produk.id);
    } else {
      itemsBaru[produk.id] = ItemKeranjang(produk: produk, jumlah: jumlahBaru);
    }

    final totalBarang = itemsBaru.values.fold(0, (t, i) => t + i.jumlah);
    final totalHarga = itemsBaru.values.fold(0, (t, i) => t + i.subtotal);
    final ongkir = totalBarang == 0 ? 0 : 12000;

    emit(KeranjangState(
      items: itemsBaru,
      totalBarang: totalBarang,
      totalHarga: totalHarga,
      ongkir: ongkir,
    ));
  }
}
