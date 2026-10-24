import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/data_laporan.dart';

/// Event untuk LaporanBloc: menambah laporan warga baru.
abstract class LaporanEvent extends Equatable {
  const LaporanEvent();

  @override
  List<Object> get props => [];
}

class TambahLaporan extends LaporanEvent {
  final LaporanWarga laporan;

  const TambahLaporan(this.laporan);

  @override
  List<Object> get props => [laporan];
}

/// State LaporanBloc: daftar laporan warga.
class LaporanState extends Equatable {
  final List<LaporanWarga> laporan;

  const LaporanState({this.laporan = const []});

  int get totalLaporan => laporan.length;

  List<LaporanWarga> get daftar => List.unmodifiable(laporan);

  LaporanState tambah(LaporanWarga laporanBaru) => LaporanState(
        laporan: [laporanBaru, ...laporan],
      );

  @override
  List<Object> get props => [laporan];
}

/// BLoC untuk state laporan warga.
class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  LaporanBloc() : super(const LaporanState(laporan: DataLaporan.daftar)) {
    on<TambahLaporan>((event, emit) {
      emit(state.tambah(event.laporan));
    });
  }
}
