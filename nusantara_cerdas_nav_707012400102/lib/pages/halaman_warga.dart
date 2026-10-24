import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorit_bloc.dart';
import '../data/data_layanan.dart';
import '../navigation/app_routes.dart';
import '../app_theme.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PROFIL', style: AppTheme.gayaEyebrow),
            const SizedBox(height: 8),
            Row(
              children: [
                // Avatar outline dengan inisial, bukan lingkaran penuh.
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primer.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'MS',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppTheme.primer,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mimkayel Sitempu', style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text('NIK 1116052001', style: textTheme.bodyMedium),
                      Text('Kelurahan Sukabirus', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            const Text('AKTIVITAS', style: AppTheme.gayaEyebrow),
            const SizedBox(height: 12),
            // Material (bukan Container berwarna) agar ink splash ListTile
            // tetap tergambar di atasnya.
            Material(
              color: AppTheme.permukaan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppTheme.garis),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: const Icon(
                  Icons.history,
                  size: 22,
                  color: AppTheme.primer,
                ),
                title: const Text('Riwayat Laporan'),
                subtitle: const Text(
                  'Lihat status laporan yang pernah diajukan',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppTheme.tekstSekunder,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
              ),
            ),
            const SizedBox(height: 28),

            // ---- Layanan Favorit (reaktif via Provider) ----------------
            const _BagianFavorit(),
          ],
        ),
      ),
    );
  }
}

/// Bagian "Layanan Favorit": dibangun ulang otomatis lewat Consumer
/// setiap kali FavoritModel berubah. Daftar digabung dari seluruh bidang
/// layanan (Perizinan, Kesehatan, Transportasi) tanpa memandang tab asal.
class _BagianFavorit extends StatelessWidget {
  const _BagianFavorit();

  /// Gabungan seluruh layanan dari semua bidang.
  static final List<LayananPublik> _semuaLayanan = [
    ...DataLayanan.perizinan,
    ...DataLayanan.kesehatan,
    ...DataLayanan.transportasi,
  ];

  @override
  Widget build(BuildContext context) {
    final favorit = context.watch<FavoritBloc>().state.favorit;
    final layananFavorit = _semuaLayanan
        .where((layanan) => favorit.contains(layanan.nama))
        .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('LAYANAN FAVORIT', style: AppTheme.gayaEyebrow),
            const SizedBox(height: 12),
            if (layananFavorit.isEmpty)
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
                      Icons.star_border,
                      size: 20,
                      color: AppTheme.tekstSekunder,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Belum ada layanan favorit. Tekan ikon bintang pada '
                        'daftar layanan untuk menandainya.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Material (bukan Container berwarna) agar ink ripple ListTile
              // tetap terlihat — pelajaran dari assertion Flutter.
              Material(
                color: AppTheme.permukaan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppTheme.garis),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (int i = 0; i < layananFavorit.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, indent: 56),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: Icon(
                          layananFavorit[i].ikon,
                          size: 22,
                          color: AppTheme.primer,
                        ),
                        title: Text(layananFavorit[i].nama),
                        subtitle: Text(layananFavorit[i].dinas),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.rincianLayanan,
                          arguments: layananFavorit[i],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      }
    }
