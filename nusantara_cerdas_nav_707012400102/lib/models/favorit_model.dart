import 'package:flutter/foundation.dart';

/// State favorit layanan publik (Modul III): daftar nama layanan yang
/// ditandai pengguna, dibagikan antar halaman via Provider.
class FavoritModel extends ChangeNotifier {
  final Set<String> _favorit = {};

  /// Salinan tak-dapat-diubah agar konsumen tidak bisa memutasinya langsung.
  Set<String> get daftarFavorit => Set.unmodifiable(_favorit);

  bool apakahFavorit(String nama) => _favorit.contains(nama);

  void tandai(String nama) {
    if (_favorit.contains(nama)) return;
    _favorit.add(nama);
    notifyListeners();
  }

  void batalTandai(String nama) {
    if (!_favorit.contains(nama)) return;
    _favorit.remove(nama);
    notifyListeners();
  }
}
