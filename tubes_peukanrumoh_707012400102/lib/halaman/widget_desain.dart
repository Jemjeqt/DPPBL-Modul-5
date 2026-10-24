import 'package:flutter/material.dart';

import 'data/data_contoh.dart';

class Warna {
  Warna._();

  static const Color teal = Color(0xFF11998E);
  static const Color tealTua = Color(0xFF0B7A70);
  static const Color tealMuda = Color(0xFFE6F6F3);
  static const Color aksen = Color(0xFFFF6F00);
  static const Color aksenMuda = Color(0xFFFFF3E0);
  static const Color bahaya = Color(0xFFD35400);

  static Color latarKategori(String kategori) {
    switch (kategori) {
      case 'Sayuran':
        return const Color(0xFF2E7D32);
      case 'Buah':
        return const Color(0xFFF9A825);
      case 'Daging':
        return const Color(0xFFC62828);
      case 'Ikan':
        return const Color(0xFF0277BD);
      case 'Bumbu':
        return const Color(0xFFEF6C00);
      case 'Sembako':
        return const Color(0xFF6D4C41);
      default:
        return teal;
    }
  }

  static Color warnaStatus(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFFF9A825);
      case 'Dikirim':
        return const Color(0xFF0277BD);
      case 'Selesai':
        return const Color(0xFF2E7D32);
      case 'Dibatalkan':
        return bahaya;
      default:
        return teal;
    }
  }
}

class ChipStatus extends StatelessWidget {
  const ChipStatus({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final warna = Warna.warnaStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: warna,
        ),
      ),
    );
  }
}

class BadgeKeranjang extends StatelessWidget {
  const BadgeKeranjang({super.key, required this.jumlah});

  final int jumlah;

  @override
  Widget build(BuildContext context) {
    if (jumlah <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Warna.aksen,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        jumlah > 99 ? '99+' : '$jumlah',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class JudulSeksi extends StatelessWidget {
  const JudulSeksi(this.judul, {super.key, this.aksi});

  final String judul;
  final String? aksi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (aksi != null)
            Text(
              aksi!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Warna.teal,
              ),
            ),
        ],
      ),
    );
  }
}

class StepperJumlah extends StatelessWidget {
  const StepperJumlah({
    super.key,
    required this.jumlah,
    required this.onTambah,
    required this.onKurangi,
    this.kecil = false,
  });

  final int jumlah;
  final VoidCallback onTambah;
  final VoidCallback onKurangi;
  final bool kecil;

  @override
  Widget build(BuildContext context) {
    final ukuran = kecil ? 30.0 : 36.0;
    final ikon = kecil ? 16.0 : 18.0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Warna.teal.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ukuran,
            height: ukuran,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: ikon,
              tooltip: 'Kurangi jumlah',
              icon: const Icon(Icons.remove),
              onPressed: onKurangi,
            ),
          ),
          SizedBox(
            width: kecil ? 24 : 32,
            child: Text(
              '$jumlah',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: kecil ? 13 : 15,
              ),
            ),
          ),
          SizedBox(
            width: ukuran,
            height: ukuran,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: ikon,
              tooltip: 'Tambah jumlah',
              icon: const Icon(Icons.add),
              onPressed: onTambah,
            ),
          ),
        ],
      ),
    );
  }
}

class KartuItemPesanan extends StatelessWidget {
  const KartuItemPesanan({super.key, required this.item});

  final ItemKeranjang item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Warna.latarKategori(item.produk.kategori)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.produk.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produk.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${item.jumlah} ${item.produk.satuan} x ${item.produk.labelHarga}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            rupiah(item.subtotal),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Warna.teal,
            ),
          ),
        ],
      ),
    );
  }
}
