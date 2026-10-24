import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/laporan_bloc.dart';
import '../data/data_laporan.dart';
import '../app_theme.dart';

/// Formulir laporan warga baru. Judul wajib diisi; tanggal diambil dari
/// hari ini; status selalu otomatis "Diajukan" saat dibuat. Setelah
/// tersimpan, halaman riwayat (yang membaca LaporanModel) otomatis
/// menampilkan laporan baru di posisi paling atas.
class HalamanFormulirLaporan extends StatefulWidget {
  const HalamanFormulirLaporan({super.key});

  @override
  State<HalamanFormulirLaporan> createState() => _HalamanFormulirLaporanState();
}

class _HalamanFormulirLaporanState extends State<HalamanFormulirLaporan> {
  final _kunciForm = GlobalKey<FormState>();
  final _kontrolerJudul = TextEditingController();
  final _kontrolerLokasi = TextEditingController();

  static const List<String> _pilihanKategori = [
    'Kebersihan',
    'Infrastruktur',
    'Penerangan',
    'Lainnya',
  ];

  String _kategori = _pilihanKategori.first;

  @override
  void dispose() {
    _kontrolerJudul.dispose();
    _kontrolerLokasi.dispose();
    super.dispose();
  }

  static const List<String> _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _tanggalHariIni() {
    final kini = DateTime.now();
    return '${kini.day} ${_namaBulan[kini.month - 1]} ${kini.year}';
  }

  Future<void> _simpan() async {
    if (!_kunciForm.currentState!.validate()) return;

    final judul = _kontrolerJudul.text.trim();
    final lokasi = _kontrolerLokasi.text.trim();

    context.read<LaporanBloc>().add(
          TambahLaporan(
            LaporanWarga(
              judul: lokasi.isEmpty ? judul : '$judul di $lokasi',
              tanggal: _tanggalHariIni(),
              status: StatusLaporan.diajukan,
            ),
          ),
        );

    if (!mounted) return;
    Navigator.pop(context, 'Laporan baru berhasil dikirim.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LAPORAN BARU', style: AppTheme.gayaEyebrow),
      ),
      body: SafeArea(
        child: Form(
          key: _kunciForm,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('CERITAKAN MASALAHNYA', style: AppTheme.gayaEyebrow),
              const SizedBox(height: 14),

              TextFormField(
                controller: _kontrolerJudul,
                decoration: const InputDecoration(
                  labelText: 'Judul laporan',
                  hintText: 'Mis. Lampu jalan mati',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (nilai) {
                  if (nilai == null || nilai.trim().isEmpty) {
                    return 'Judul laporan wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _kontrolerLokasi,
                decoration: const InputDecoration(
                  labelText: 'Lokasi (opsional)',
                  hintText: 'Mis. Jalan Merdeka',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _pilihanKategori
                    .map(
                      (kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ),
                    )
                    .toList(),
                onChanged: (nilai) {
                  if (nilai != null) setState(() => _kategori = nilai);
                },
              ),
              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Kirim Laporan'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Laporan akan tampil di halaman Riwayat Laporan setelah '
                'dikirim.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
