// Smoke test: aplikasi harus berhasil build tanpa error, menampilkan
// beranda (pita status dan daftar pilar), dan aksi cepat "Semua Layanan"
// berpindah ke tab Layanan.
//
// Catatan: test bawaan 'flutter create' (MyApp/counter) sudah lama tidak
// cocok dengan aplikasi ini dan selalu gagal, sehingga diganti.

import 'package:flutter_test/flutter_test.dart';

import 'package:usantara_cerdas_nav_707012400102/main.dart';

void main() {
  testWidgets('Beranda tampil dengan pita status dan pilar kota',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();

    // Pita status kota.
    expect(find.text('24/7'), findsOneWidget);
    expect(find.text('STATUS LAYANAN'), findsOneWidget);

    // Daftar pilar.
    expect(find.text('ENAM PILAR KOTA'), findsOneWidget);
    expect(find.text('Smart Governance'), findsOneWidget);
    expect(find.text('Smart Environment'), findsOneWidget);
  });

  testWidgets('Aksi cepat membuka tab Layanan', (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiNusantaraCerdas());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Semua Layanan'));
    await tester.pumpAndSettle();

    expect(find.text('Perizinan'), findsOneWidget);
    expect(find.text('Transportasi'), findsOneWidget);
  });
}
