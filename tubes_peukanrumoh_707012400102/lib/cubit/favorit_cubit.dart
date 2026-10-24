import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorit_state.dart';

class FavoritCubit extends Cubit<FavoritState> {
  FavoritCubit() : super(const FavoritState());

  void tambah(int idProduk) {
    final favoritesBaru = Set<int>.from(state.favorites)..add(idProduk);
    emit(FavoritState(favorites: favoritesBaru));
  }

  void hapus(int idProduk) {
    final favoritesBaru = Set<int>.from(state.favorites)..remove(idProduk);
    emit(FavoritState(favorites: favoritesBaru));
  }

  void toggle(int idProduk) {
    if (state.cek(idProduk)) {
      hapus(idProduk);
    } else {
      tambah(idProduk);
    }
  }

  void kosongkan() {
    emit(const FavoritState());
  }
}
