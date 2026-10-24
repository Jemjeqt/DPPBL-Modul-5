import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/produk.dart';

// Event: daftar aksi yang bisa dikirim ke KeranjangBloc
abstract class KeranjangEvent {}

class TambahProduk extends KeranjangEvent {
  TambahProduk(this.produk);
  final Produk produk;
}

class KurangiProduk extends KeranjangEvent {
  KurangiProduk(this.produk);
  final Produk produk;
}

class KosongkanKeranjang extends KeranjangEvent {}

// State: data yang ditampilkan ke layar
class KeranjangState {
  const KeranjangState(this.items);
  final List<ItemKeranjang> items;
}

// Bloc: menerima Event, lalu mengeluarkan State baru
class KeranjangBloc extends Bloc<KeranjangEvent, KeranjangState> {
  KeranjangBloc() : super(const KeranjangState([])) {
    on<TambahProduk>((event, emit) {
      final daftar = List<ItemKeranjang>.from(state.items);
      final indeks =
          daftar.indexWhere((item) => item.produk.nama == event.produk.nama);

      if (indeks == -1) {
        daftar.add(ItemKeranjang(produk: event.produk));
      } else {
        daftar[indeks] = ItemKeranjang(
          produk: event.produk,
          jumlah: daftar[indeks].jumlah + 1,
        );
      }

      emit(KeranjangState(daftar));
    });

    on<KurangiProduk>((event, emit) {
      final daftar = List<ItemKeranjang>.from(state.items);
      final indeks =
          daftar.indexWhere((item) => item.produk.nama == event.produk.nama);
      if (indeks == -1) return;

      if (daftar[indeks].jumlah == 1) {
        daftar.removeAt(indeks);
      } else {
        daftar[indeks] = ItemKeranjang(
          produk: event.produk,
          jumlah: daftar[indeks].jumlah - 1,
        );
      }

      emit(KeranjangState(daftar));
    });

    on<KosongkanKeranjang>((event, emit) {
      emit(const KeranjangState([]));
    });
  }
}