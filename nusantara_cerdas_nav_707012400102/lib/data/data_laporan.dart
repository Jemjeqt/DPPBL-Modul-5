/// Model dan data contoh untuk riwayat laporan warga pada halaman Warga.
enum StatusLaporan { diajukan, diproses, selesai }

class LaporanWarga {
  const LaporanWarga({
    required this.judul,
    required this.tanggal,
    required this.status,
  });

  final String judul;
  final String tanggal;
  final StatusLaporan status;
}

class DataLaporan {
  DataLaporan._();

  static const List<LaporanWarga> daftar = [
    LaporanWarga(
      judul: 'Lampu Jalan Mati di Jalan Merdeka',
      tanggal: '18 September 2026',
      status: StatusLaporan.diproses,
    ),
    LaporanWarga(
      judul: 'Jalan Berlubang di Jalan Sudirman',
      tanggal: '10 September 2026',
      status: StatusLaporan.selesai,
    ),
    LaporanWarga(
      judul: 'Sampah Menumpuk di Taman Kota',
      tanggal: '22 September 2026',
      status: StatusLaporan.diajukan,
    ),
  ];
}
