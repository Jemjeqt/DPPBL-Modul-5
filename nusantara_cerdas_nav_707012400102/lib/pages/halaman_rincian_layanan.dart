import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pengajuan_bloc.dart';
import '../data/data_layanan.dart';
import '../app_theme.dart';

/// Halaman rincian satu layanan publik. Data diterima lewat arguments pada
/// named route (bukan nilai tetap). Tombol Ajukan Permohonan menampilkan
/// indikator singkat, menambah pengajuan ke PengajuanModel (Provider),
/// lalu mengirim nilai balik lewat Navigator.pop untuk snackbar di
/// halaman sebelumnya.
class HalamanRincianLayanan extends StatefulWidget {
  const HalamanRincianLayanan({super.key, required this.layanan});

  final LayananPublik layanan;

  @override
  State<HalamanRincianLayanan> createState() => _HalamanRincianLayananState();
}

class _HalamanRincianLayananState extends State<HalamanRincianLayanan> {
  bool _sedangMengirim = false;

  Future<void> _ajukanPermohonan() async {
    // Guard dobel-klik: abaikan bila pengiriman sedang berjalan.
    if (_sedangMengirim) return;

    setState(() => _sedangMengirim = true);

    // Simulasi waktu pengiriman ke server.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    context.read<PengajuanBloc>().add(AjukanLayanan(widget.layanan.nama));

    Navigator.pop(
      context,
      'Permohonan "${widget.layanan.nama}" telah diajukan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final layanan = widget.layanan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RINCIAN LAYANAN', style: AppTheme.gayaEyebrow),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon aksen kecil, bukan blob besar.
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(layanan.ikon, size: 22, color: AppTheme.primer),
              ),
              const SizedBox(height: 14),
              Text(layanan.nama, style: textTheme.headlineSmall),
              const SizedBox(height: 24),

              // Info layanan: satu panel putih, pemisah hairline di dalam.
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.permukaan,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.garis),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _BarisInfo(
                      ikon: Icons.apartment_outlined,
                      label: 'DINAS PENANGGUNG JAWAB',
                      nilai: layanan.dinas,
                    ),
                    const Divider(height: 1, indent: 56),
                    _BarisInfo(
                      ikon: Icons.schedule_outlined,
                      label: 'JAM OPERASIONAL',
                      nilai: layanan.jam,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('KETERANGAN', style: AppTheme.gayaEyebrow),
              const SizedBox(height: 8),
              Text(layanan.keterangan, style: textTheme.bodyLarge),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sedangMengirim ? null : _ajukanPermohonan,
                  child: _sedangMengirim
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Ajukan Permohonan'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarisInfo extends StatelessWidget {
  const _BarisInfo({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: AppTheme.tekstSekunder),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.gayaEyebrow),
                const SizedBox(height: 3),
                Text(nilai, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
