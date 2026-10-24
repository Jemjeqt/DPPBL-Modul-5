import 'package:flutter/foundation.dart';

/// State pengajuan layanan (Modul III): daftar nama layanan yang sedang
/// diajukan, dipantau badge tujuan Warga dan halaman Riwayat Laporan.
class PengajuanModel extends ChangeNotifier {
  final List<String> _sedangDiajukan = [];

  List<String> get daftarPengajuan => List.unmodifiable(_sedangDiajukan);

  int get totalPengajuan => _sedangDiajukan.length;

  void tambah(String nama) {
    _sedangDiajukan.add(nama);
    notifyListeners();
  }

  /// Menghapus kemunculan pertama; tidak melakukan apa-apa bila tidak ada.
  void batalkan(String nama) {
    final indeks = _sedangDiajukan.indexOf(nama);
    if (indeks == -1) return;
    _sedangDiajukan.removeAt(indeks);
    notifyListeners();
  }
}
