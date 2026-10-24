import 'package:flutter/material.dart';

/// Model satu layanan publik.
class LayananPublik {
  const LayananPublik({
    required this.nama,
    required this.dinas,
    required this.jam,
    required this.keterangan,
    required this.ikon,
  });

  final String nama;
  final String dinas;
  final String jam;
  final String keterangan;
  final IconData ikon;
}

/// Data contoh layanan publik, dikelompokkan per bidang untuk masing-masing
/// tab pada halaman Layanan (Perizinan, Kesehatan, Transportasi).
class DataLayanan {
  DataLayanan._();

  static const List<LayananPublik> perizinan = [
    LayananPublik(
      nama: 'Izin Usaha Mikro Kecil',
      dinas: 'Dinas Penanaman Modal dan PTSP',
      jam: 'Senin–Jumat, 08.00–15.00',
      keterangan:
          'Pengajuan izin usaha bagi pelaku UMKM warga Kota Nusantara.',
      ikon: Icons.storefront_outlined,
    ),
    LayananPublik(
      nama: 'Izin Mendirikan Bangunan',
      dinas: 'Dinas Pekerjaan Umum dan Penataan Ruang',
      jam: 'Senin–Jumat, 08.00–14.00',
      keterangan:
          'Pengajuan izin pembangunan atau renovasi properti warga.',
      ikon: Icons.home_work_outlined,
    ),
    LayananPublik(
      nama: 'Izin Keramaian dan Acara',
      dinas: 'Satuan Polisi Pamong Praja',
      jam: 'Senin–Sabtu, 08.00–16.00',
      keterangan: 'Izin penyelenggaraan kegiatan warga di ruang publik.',
      ikon: Icons.celebration_outlined,
    ),
  ];

  static const List<LayananPublik> kesehatan = [
    LayananPublik(
      nama: 'Pendaftaran BPJS Mandiri',
      dinas: 'Dinas Kesehatan',
      jam: 'Senin–Jumat, 07.30–14.00',
      keterangan:
          'Pendaftaran kepesertaan BPJS Kesehatan bagi warga mandiri.',
      ikon: Icons.badge_outlined,
    ),
    LayananPublik(
      nama: 'Jadwal Vaksinasi Puskesmas',
      dinas: 'Dinas Kesehatan',
      jam: 'Senin–Sabtu, 08.00–12.00',
      keterangan:
          'Informasi dan reservasi jadwal vaksinasi di puskesmas terdekat.',
      ikon: Icons.vaccines_outlined,
    ),
    LayananPublik(
      nama: 'Konsultasi Dokter Daring',
      dinas: 'Dinas Kesehatan',
      jam: 'Setiap hari, 08.00–20.00',
      keterangan:
          'Layanan konsultasi kesehatan jarak jauh dengan dokter puskesmas.',
      ikon: Icons.medical_services_outlined,
    ),
  ];

  static const List<LayananPublik> transportasi = [
    LayananPublik(
      nama: 'Perpanjangan SIM Keliling',
      dinas: 'Satuan Lalu Lintas Polres',
      jam: 'Senin–Jumat, 08.00–13.00',
      keterangan:
          'Layanan perpanjangan SIM tanpa perlu datang ke kantor polisi.',
      ikon: Icons.assignment_ind_outlined,
    ),
    LayananPublik(
      nama: 'Pengaduan Angkutan Umum',
      dinas: 'Dinas Perhubungan',
      jam: 'Senin–Jumat, 08.00–16.00',
      keterangan:
          'Pengaduan terkait pelayanan atau kondisi angkutan umum kota.',
      ikon: Icons.report_gmailerrorred_outlined,
    ),
    LayananPublik(
      nama: 'Rute dan Jadwal Bus Kota',
      dinas: 'Dinas Perhubungan',
      jam: 'Setiap hari, 05.00–22.00',
      keterangan: 'Informasi rute, jadwal, dan tarif bus kota terkini.',
      ikon: Icons.directions_bus_filled_outlined,
    ),
  ];
}
