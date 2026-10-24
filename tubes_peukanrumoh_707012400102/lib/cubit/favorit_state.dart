import 'package:equatable/equatable.dart';

class FavoritState extends Equatable {
  const FavoritState({
    this.favorites = const {},
  });

  final Set<int> favorites;

  int get jumlah => favorites.length;

  bool cek(int idProduk) => favorites.contains(idProduk);

  FavoritState copyWith({
    Set<int>? favorites,
  }) {
    return FavoritState(
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [favorites];
}
