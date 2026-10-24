import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pengajuan_bloc.dart';
import '../data/data_laporan.dart';
import '../data/data_layanan.dart';
import '../bloc/laporan_bloc.dart';
import '../app_theme.dart';

/// Riwayat Laporan reaktif: bagian atas menampilkan pengajuan layanan
/// (PengajuanModel), lalu daftar laporan warga (LaporanModel). Tidak ada
/// lagi FAB/BottomAppBar placeholder — pembuatan laporan dipindah ke
/// panel Buat Laporan Baru di Beranda.
class HalamanRiwayatLaporan extends StatelessWidget {
  const HalamanRiwayatLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    final laporanState = context.watch<LaporanBloc>().state;
    final daftarLaporan = laporanState.laporan;
    // Slot 0 = bagian pengajuan (satu widget utuh), slot 1 = header,
    // slot selanjutnya = satu per satu laporan warga.
    final jumlahItem = daftarLaporan.length + 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RIWAYAT LAPORAN', style: AppTheme.gayaEyebrow),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: jumlahItem,
        itemBuilder: (context, indeks) {
          // Slot 0: bagian pengajuan layanan.
          if (indeks == 0) {
            return const _BagianPengajuan();
          }

          // Slot 1: header daftar laporan warga.
          if (indeks == 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 4),
              child: Text(
                'LAPORAN WARGA (${daftarLaporan.length})',
                style: AppTheme.gayaEyebrow,
              ),
            );
          }

          final indeksLaporan = indeks - 2;
          final terakhir = indeksLaporan == daftarLaporan.length - 1;

          return _BarisLaporan(
            laporan: daftarLaporan[indeksLaporan],
            nomor: indeksLaporan + 1,
            garisBawah: !terakhir,
          );
        },
      ),
    );
  }
}

/// Bagian "PENGAJUAN LAYANAN (n)": Consumer terpisah agar hanya bagian ini
/// yang rebuild saat pengajuan ditambah/dibatalkan.
class _BagianPengajuan extends StatelessWidget {
  const _BagianPengajuan();

  @override
  Widget build(BuildContext context) {
    final pengajuanState = context.watch<PengajuanBloc>().state;
    final daftar = pengajuanState.pengajuan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            'PENGAJUAN LAYANAN (${daftar.length})',
            style: AppTheme.gayaEyebrow,
          ),
        ),
        if (daftar.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.permukaan,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.garis),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  size: 20,
                  color: AppTheme.tekstSekunder,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Belum ada pengajuan. Buka tab Layanan lalu tekan '
                    '"Ajukan Permohonan".',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              for (int i = 0; i < daftar.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _BarisPengajuan(
                  nama: daftar[i],
                  garisBawah: i < daftar.length - 1,
                ),
              ],
            ],
          ),
      ],
    );
  }
}

/// Baris pengajuan: gaya editorial sama dengan _BarisLaporan — slot nomor,
/// judul + dinas, chip status kompak di kanan, lalu tombol batalkan.
class _BarisPengajuan extends StatelessWidget {
  const _BarisPengajuan({required this.nama, required this.garisBawah});

  final String nama;
  final bool garisBawah;

  /// Mencari dinas pemilik layanan dari seluruh bidang data.
  static LayananPublik? _cariLayanan(String nama) {
    final semua = [
      ...DataLayanan.perizinan,
      ...DataLayanan.kesehatan,
      ...DataLayanan.transportasi,
    ];
    for (final layanan in semua) {
      if (layanan.nama == nama) return layanan;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final layanan = _cariLayanan(nama);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 34,
                child: Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: AppTheme.aksen,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      layanan?.dinas ?? 'Dinas terkait',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _ChipStatus(status: StatusLaporan.diajukan),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                width: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  tooltip: 'Batalkan pengajuan',
                  icon: const Icon(Icons.close),
                  color: AppTheme.tekstSekunder,
                  onPressed: () {
                    context.read<PengajuanBloc>().add(BatalkanPengajuan(nama));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Pengajuan "$nama" dibatalkan.'),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
        if (garisBawah) const Divider(height: 1),
      ],
    );
  }
}

class _BarisLaporan extends StatelessWidget {
  const _BarisLaporan({
    required this.laporan,
    required this.nomor,
    required this.garisBawah,
  });

  final LaporanWarga laporan;
  final int nomor;
  final bool garisBawah;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 34,
                child: Text(
                  '$nomor'.padLeft(2, '0'),
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.aksen,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(laporan.judul, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(laporan.tanggal, style: textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ChipStatus(status: laporan.status),
            ],
          ),
        ),
        if (garisBawah) const Divider(height: 1),
      ],
    );
  }
}

class _ChipStatus extends StatelessWidget {
  const _ChipStatus({required this.status});

  final StatusLaporan status;

  @override
  Widget build(BuildContext context) {
    late final Color warna;
    late final String label;

    switch (status) {
      case StatusLaporan.diajukan:
        warna = AppTheme.aksen;
        label = 'Diajukan';
        break;
      case StatusLaporan.diproses:
        warna = AppTheme.primer;
        label = 'Diproses';
        break;
      case StatusLaporan.selesai:
        warna = const Color(0xFF2E7D32);
        label = 'Selesai';
        break;
    }

    // Chip outline tipis dengan titik warna — lebih tenang daripada
    // pil berlatar penuh.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warna.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: warna,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
