class ProdukContoh {
  const ProdukContoh({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.satuan,
    required this.emoji,
    required this.penjual,
    required this.deskripsi,
    this.penilaian = 4.8,
  });

  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String satuan;
  final String emoji;
  final String penjual;
  final String deskripsi;
  final double penilaian;

  String get labelHarga => rupiah(harga);
}

const List<ProdukContoh> daftarProdukContoh = [
  ProdukContoh(
    id: 1,
    nama: 'Bayam Segar',
    kategori: 'Sayuran',
    harga: 8000,
    satuan: 'iket',
    emoji: '🥬',
    penjual: 'Kios Sayur Cut Meutia',
    deskripsi:
        'Bayam hijau segar dipetik pagi dari kebun sekitar Banda Aceh. Cocok '
        'untuk tumis dan sayur kuah.',
  ),
  ProdukContoh(
    id: 2,
    nama: 'Kangkung Hidroponik',
    kategori: 'Sayuran',
    harga: 5000,
    satuan: 'ikat',
    emoji: '🌿',
    penjual: 'Kios Sayur Cut Meutia',
    deskripsi: 'Kangkung renyah bebas pestisida, panen harian.',
  ),
  ProdukContoh(
    id: 3,
    nama: 'Mangga Harum Manis (3 pcs)',
    kategori: 'Buah',
    harga: 25000,
    satuan: 'pack',
    emoji: '🥭',
    penjual: 'Toko Buah Lambaro',
    deskripsi: 'Mangga matang pohon, manis dan berair.',
  ),
  ProdukContoh(
    id: 4,
    nama: 'Pisang Tanduk 1 Sisir',
    kategori: 'Buah',
    harga: 18000,
    satuan: 'sisir',
    emoji: '🍌',
    penjual: 'Toko Buah Lambaro',
    deskripsi: 'Pisang tanduk untuk pisang goreng dan keulabab.',
  ),
  ProdukContoh(
    id: 5,
    nama: 'Ayam Potong Segar 1 Kg',
    kategori: 'Daging',
    harga: 38000,
    satuan: 'kg',
    emoji: '🍗',
    penjual: 'Rumah Potong Jeulingke',
    deskripsi: 'Ayam broiler segar, sudah dibersihkan, siap potong.',
  ),
  ProdukContoh(
    id: 6,
    nama: 'Ikan Kembung Segar',
    kategori: 'Ikan',
    harga: 32000,
    satuan: 'kg',
    emoji: '🐟',
    penjual: 'Peukan Ikan Ulee Lheue',
    deskripsi: 'Hasil tangkapan pagi, mata masih bening.',
  ),
  ProdukContoh(
    id: 7,
    nama: 'Bumbu Rendang Instan',
    kategori: 'Bumbu',
    harga: 12000,
    satuan: 'bks',
    emoji: '🌶️',
    penjual: 'Dapur Bunda Aceh',
    deskripsi: 'Bumbu rendang khas Aceh, cukup untuk 1 kg daging.',
  ),
  ProdukContoh(
    id: 8,
    nama: 'Beras Premium 5 Kg',
    kategori: 'Sembako',
    harga: 72000,
    satuan: 'sak kecil',
    emoji: '🌾',
    penjual: 'Kios Sembako Peunayong',
    deskripsi: 'Beras pulen putih bersih, tahan lama dan wangi.',
  ),
];

const List<String> daftarKategori = [
  'Semua',
  'Sayuran',
  'Buah',
  'Daging',
  'Ikan',
  'Bumbu',
  'Sembako',
];

ProdukContoh? cariProdukContoh(int? id) {
  for (final produk in daftarProdukContoh) {
    if (produk.id == id) return produk;
  }
  return null;
}

class ItemKeranjang {
  const ItemKeranjang({required this.produk, required this.jumlah});

  final ProdukContoh produk;
  final int jumlah;

  int get subtotal => produk.harga * jumlah;
}

class PesananContoh {
  const PesananContoh({
    required this.id,
    required this.tanggalLabel,
    required this.status,
    required this.item,
    required this.alamat,
    required this.metodeBayar,
  });

  static const List<String> daftarStatus = [
    'Diproses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  final int id;
  final String tanggalLabel;
  final String status;
  final List<ItemKeranjang> item;
  final String alamat;
  final String metodeBayar;

  int get subtotal =>
      item.fold(0, (total, item) => total + item.subtotal);

  int get ongkos => item.isEmpty ? 0 : 12000;

  int get total => subtotal + ongkos;
}

final List<PesananContoh> daftarPesananContoh = [
  PesananContoh(
    id: 2401,
    tanggalLabel: '24 Sep 2026',
    status: 'Diproses',
    alamat: 'Jl. T. Nyak Arief No. 12, Banda Aceh',
    metodeBayar: 'Transfer Bank',
    item: [
      ItemKeranjang(produk: daftarProdukContoh[0], jumlah: 3),
      ItemKeranjang(produk: daftarProdukContoh[2], jumlah: 1),
    ],
  ),
  PesananContoh(
    id: 2395,
    tanggalLabel: '21 Sep 2026',
    status: 'Dikirim',
    alamat: 'Jl. T. Nyak Arief No. 12, Banda Aceh',
    metodeBayar: 'COD',
    item: [
      ItemKeranjang(produk: daftarProdukContoh[5], jumlah: 1),
      ItemKeranjang(produk: daftarProdukContoh[4], jumlah: 1),
    ],
  ),
  PesananContoh(
    id: 2310,
    tanggalLabel: '12 Sep 2026',
    status: 'Selesai',
    alamat: 'Jl. Pocut Baren No. 3, Banda Aceh',
    metodeBayar: 'Transfer Bank',
    item: [ItemKeranjang(produk: daftarProdukContoh[7], jumlah: 2)],
  ),
];

class ProfilContoh {
  const ProfilContoh({
    required this.nama,
    required this.email,
    required this.telepon,
    required this.alamat,
  });

  final String nama;
  final String email;
  final String telepon;
  final String alamat;
}

const ProfilContoh profilContoh = ProfilContoh(
  nama: 'Budi Aceh',
  email: 'budi@peukanrumoh.id',
  telepon: '0812-3456-7890',
  alamat: 'Jl. T. Nyak Arief No. 12, Banda Aceh',
);

String rupiah(int angka) {
  final digit = angka.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digit.length; i++) {
    final sisa = digit.length - i;
    buffer.write(digit[i]);
    if (sisa > 1 && (sisa - 1) % 3 == 0) buffer.write('.');
  }
  return 'Rp $buffer';
}
