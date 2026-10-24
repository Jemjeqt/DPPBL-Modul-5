import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Event untuk FavoritBloc: menandai atau membatalkan favorit layanan.
abstract class FavoritEvent extends Equatable {
  const FavoritEvent();

  @override
  List<Object> get props => [];
}

class TandaiLayanan extends FavoritEvent {
  final String namaLayanan;

  const TandaiLayanan(this.namaLayanan);

  @override
  List<Object> get props => [namaLayanan];
}

class BatalTandaiLayanan extends FavoritEvent {
  final String namaLayanan;

  const BatalTandaiLayanan(this.namaLayanan);

  @override
  List<Object> get props => [namaLayanan];
}

/// State FavoritBloc: set nama layanan yang difavoritkan.
class FavoritState extends Equatable {
  final Set<String> favorit;

  const FavoritState({this.favorit = const {}});

  bool apakahFavorit(String nama) => favorit.contains(nama);

  FavoritState tandai(String nama) => FavoritState(favorit: {...favorit, nama});

  FavoritState batalTandai(String nama) => FavoritState(
        favorit: Set.from(favorit)..remove(nama),
      );

  @override
  List<Object> get props => [favorit];
}

/// BLoC untuk state favorit layanan.
class FavoritBloc extends Bloc<FavoritEvent, FavoritState> {
  FavoritBloc() : super(const FavoritState()) {
    on<TandaiLayanan>((event, emit) {
      emit(state.tandai(event.namaLayanan));
    });

    on<BatalTandaiLayanan>((event, emit) {
      emit(state.batalTandai(event.namaLayanan));
    });
  }
}
