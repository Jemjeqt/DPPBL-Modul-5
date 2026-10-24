import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorit_bloc.dart';
import '../data/data_layanan.dart';
import '../navigation/app_routes.dart';
import '../app_theme.dart';

/// Versi halaman penuh dari daftar layanan, dibuka sebagai route dari
/// aksi cepat "Semua Layanan" pada Beranda (pola pushNamed sama seperti
/// tujuan Riwayat Laporan).
class HalamanLayananRoute extends StatelessWidget {
  const HalamanLayananRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAYANAN', style: AppTheme.gayaEyebrow),
      ),
      body: const HalamanLayanan(),
    );
  }
}

class HalamanLayanan extends StatefulWidget {
  const HalamanLayanan({super.key});

  @override
  State<HalamanLayanan> createState() => _HalamanLayananState();
}

class _HalamanLayananState extends State<HalamanLayanan> {
  Future<void> _bukaRincian(LayananPublik layanan) async {
    final hasil = await Navigator.pushNamed(
      context,
      AppRoutes.rincianLayanan,
      arguments: layanan,
    );
    if (!mounted) return;
    if (hasil is String) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(hasil)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Material(
            color: AppTheme.latar,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: 14),
              dividerColor: AppTheme.garis,
              tabs: [
                Tab(text: 'Perizinan'),
                Tab(text: 'Kesehatan'),
                Tab(text: 'Transportasi'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _daftarLayanan(DataLayanan.perizinan),
                _daftarLayanan(DataLayanan.kesehatan),
                _daftarLayanan(DataLayanan.transportasi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _daftarLayanan(List<LayananPublik> daftar) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: daftar.length + 1,
      itemBuilder: (context, indeks) {
        if (indeks == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              '${daftar.length} LAYANAN TERSEDIA',
              style: AppTheme.gayaEyebrow,
            ),
          );
        }
        final layanan = daftar[indeks - 1];
        final terakhir = indeks == daftar.length;

        return _BarisLayanan(
          layanan: layanan,
          nomor: indeks,
          garisBawah: !terakhir,
          onTap: () => _bukaRincian(layanan),
        );
      },
    );
  }
}

class _BarisLayanan extends StatelessWidget {
  const _BarisLayanan({
    required this.layanan,
    required this.nomor,
    required this.garisBawah,
    required this.onTap,
  });

  final LayananPublik layanan;
  final int nomor;
  final bool garisBawah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
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
                      Text(layanan.nama, style: textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text(
                        layanan.dinas,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IkonFavorit(nama: layanan.nama),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: AppTheme.tekstSekunder,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (garisBawah) const Divider(height: 1),
        ],
      ),
    );
  }
}

class _IkonFavorit extends StatelessWidget {
  const _IkonFavorit({required this.nama});

  final String nama;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritBloc, FavoritState>(
      buildWhen: (previous, current) => previous.apakahFavorit(nama) != current.apakahFavorit(nama),
      builder: (context, state) {
        final apakahFavorit = state.apakahFavorit(nama);

        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 44),
          iconSize: 20,
          tooltip: apakahFavorit ? 'Batal tandai favorit' : 'Tandai sebagai favorit',
          icon: Icon(
            apakahFavorit ? Icons.star : Icons.star_border,
            color: apakahFavorit ? AppTheme.aksen : AppTheme.tekstSekunder,
          ),
          onPressed: () {
            final favoritBloc = context.read<FavoritBloc>();
            if (apakahFavorit) {
              favoritBloc.add(BatalTandaiLayanan(nama));
            } else {
              favoritBloc.add(TandaiLayanan(nama));
            }
          },
        );
      },
    );
  }
}
