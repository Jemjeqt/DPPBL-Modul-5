import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Event untuk PengajuanBloc: menambah atau membatalkan pengajuan layanan.
abstract class PengajuanEvent extends Equatable {
  const PengajuanEvent();

  @override
  List<Object> get props => [];
}

class AjukanLayanan extends PengajuanEvent {
  final String namaLayanan;

  const AjukanLayanan(this.namaLayanan);

  @override
  List<Object> get props => [namaLayanan];
}

class BatalkanPengajuan extends PengajuanEvent {
  final String namaLayanan;

  const BatalkanPengajuan(this.namaLayanan);

  @override
  List<Object> get props => [namaLayanan];
}

/// State PengajuanBloc: daftar nama layanan yang sedang diajukan.
class PengajuanState extends Equatable {
  final List<String> pengajuan;

  const PengajuanState({this.pengajuan = const []});

  int get totalPengajuan => pengajuan.length;

  List<String> get daftarPengajuan => List.unmodifiable(pengajuan);

  PengajuanState tambah(String nama) => PengajuanState(
        pengajuan: [...pengajuan, nama],
      );

  PengajuanState batalkan(String nama) {
    final indeks = pengajuan.indexOf(nama);
    if (indeks == -1) return this;
    return PengajuanState(
      pengajuan: [...pengajuan]..removeAt(indeks),
    );
  }

  @override
  List<Object> get props => [pengajuan];
}

/// BLoC untuk state pengajuan layanan.
class PengajuanBloc extends Bloc<PengajuanEvent, PengajuanState> {
  PengajuanBloc() : super(const PengajuanState()) {
    on<AjukanLayanan>((event, emit) {
      emit(state.tambah(event.namaLayanan));
    });

    on<BatalkanPengajuan>((event, emit) {
      emit(state.batalkan(event.namaLayanan));
    });
  }

  int get totalPengajuan => state.totalPengajuan;
}
