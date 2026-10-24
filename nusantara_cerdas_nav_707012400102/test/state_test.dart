// Test Modul III: state management dengan Provider.
//
// 1. Ikon bintang pada kartu layanan menandai favorit; daftar favorit
//    tampil reaktif pada tujuan Warga (Consumer<FavoritModel>).
// 2. Tombol Ajukan Permohonan menampilkan indikator singkat (state lokal
//    setState), lalu menambah pengajuan sehingga badge di ikon tujuan
//    Warga bertambah (context.select<PengajuanModel, int>).
// 3. Layar lebar (NavigationRail) juga berada di bawah scope provider —
//    tidak ada ProviderNotFoundException.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:usantara_cerdas_nav_707012400102/main.dart';

void main() {
  Future<void> bukaTabLayanan(WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Layanan').last);
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Ikon bintang menandai favorit dan tampil di Layanan Favorit tujuan Warga',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();

    // Buka tujuan Layanan melalui NavigationBar.
    await tester.tap(find.text('Layanan').last);
    await tester.pumpAndSettle();

    // Tandai satu layanan sebagai favorit lewat ikon bintangnya.
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pumpAndSettle();

    // Pindah ke tujuan Warga: bagian Layanan Favorit harus reaktif.
    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();

    expect(find.text('LAYANAN FAVORIT'), findsOneWidget);
    expect(find.text('Izin Usaha Mikro Kecil'), findsOneWidget);
  });

  testWidgets(
      'Ajukan Permohonan menampilkan indikator lalu badge Warga bertambah',
      (WidgetTester tester) async {
    await bukaTabLayanan(tester);

    // Buka rincian layanan pertama.
    await tester.tap(find.text('Izin Usaha Mikro Kecil'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajukan Permohonan'));
    await tester.pump(); // frame pertama: indikator muncul.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tunggu simulasi pengiriman selesai + pop + snackbar.
    await tester.pumpAndSettle();

    // Kembali ke daftar: nilai balik ditampilkan sebagai snackbar.
    expect(
      find.textContaining('telah diajukan'),
      findsOneWidget,
    );

    // Pindah ke tujuan Warga via NavigationBar: badge harus berisi "1".
    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets(
      'Pengajuan muncul di Riwayat Laporan dan bisa dibatalkan',
      (WidgetTester tester) async {
    await bukaTabLayanan(tester);

    // Ajukan satu permohonan dari halaman rincian.
    await tester.tap(find.text('Izin Usaha Mikro Kecil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajukan Permohonan'));
    await tester.pumpAndSettle();

    // Buka halaman Riwayat Laporan lewat tujuan Warga.
    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat Laporan'));
    await tester.pumpAndSettle();

    // Pengajuan tampil sinkron di bagian PENGAJUAN LAYANAN.
    expect(find.text('PENGAJUAN LAYANAN (1)'), findsOneWidget);
    expect(find.text('Izin Usaha Mikro Kecil'), findsOneWidget);

    // Batalkan: daftar kembali kosong (badge Warga ikut turun).
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('PENGAJUAN LAYANAN (0)'), findsOneWidget);
    expect(find.textContaining('dibatalkan'), findsOneWidget);
  });

  testWidgets(
      'Formulir laporan baru menambah laporan ke daftar riwayat',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();

    // Buka panel Buat Laporan Baru di Beranda.
    await tester.tap(find.text('Buat Laporan Baru'));
    await tester.pumpAndSettle();

    // Isi judul lalu kirim.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Judul laporan'),
      'Trotoar Retak',
    );
    await tester.tap(find.text('Kirim Laporan'));
    await tester.pumpAndSettle();

    // Kembali ke Beranda dengan snackbar konfirmasi.
    expect(find.textContaining('berhasil dikirim'), findsOneWidget);

    // Buka riwayat lewat aksi cepat: jumlah bertambah, laporan terbaru di atas.
    await tester.tap(find.text('Laporan Saya'));
    await tester.pumpAndSettle();
    expect(find.text('LAPORAN WARGA (4)'), findsOneWidget);
    expect(find.text('Trotoar Retak'), findsOneWidget);
  });

  testWidgets('Layar lebar memakai NavigationRail tanpa ProviderNotFoundException',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);

    // Pindah tujuan lewat rail: konten tetap terbentuk tanpa exception.
    await tester.tap(find.text('Layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Perizinan'), findsOneWidget);

    await tester.tap(find.text('Warga'));
    await tester.pumpAndSettle();
    expect(find.text('LAYANAN FAVORIT'), findsOneWidget);
  });
}
