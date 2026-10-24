import 'package:flutter/foundation.dart';

import '../data/data_laporan.dart';

/// State laporan warga (Modul III): diinisialisasi dari data contoh,
/// lalu bertambah saat pengguna mengirim formulir laporan baru.
class LaporanModel extends ChangeNotifier {
  LaporanModel() : _daftar = [...DataLaporan.daftar];

  final List<LaporanWarga> _daftar;

  List<LaporanWarga> get daftar => List.unmodifiable(_daftar);

  int get totalLaporan => _daftar.length;

  /// Laporan terbaru selalu ditaruh paling atas.
  void tambahLaporan(LaporanWarga laporan) {
    _daftar.insert(0, laporan);
    notifyListeners();
  }
}
