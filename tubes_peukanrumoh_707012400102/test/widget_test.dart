import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tubes_peukanrumoh_707012400102/main.dart';
import 'package:tubes_peukanrumoh_707012400102/navigation/kerangka_navigasi.dart';
import 'package:tubes_peukanrumoh_707012400102/theme/theme_controller.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, {Size size = const Size(400, 900)}) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    addTearDown(() {
      ThemeController.instance.setDark(false);
    });

    await tester.pumpWidget(const PeukanRumohApp());
    await tester.pumpAndSettle();
  }

  testWidgets('route salah tulis jatuh ke halaman tidak ditemukan', (tester) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(KerangkaUtama));
    Navigator.of(context).pushNamed('/prodak');
    await tester.pumpAndSettle();

    expect(find.text('Halaman tidak ditemukan'), findsOneWidget);
    expect(find.textContaining('/prodak'), findsOneWidget);
  });

  testWidgets('Navigation Bar tampil di layar sempit', (tester) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('Navigation Rail menggantikan Navigation Bar di layar lebar', (tester) async {
    await pumpApp(tester, size: const Size(1200, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('drawer berisi Tentang Aplikasi dan bisa dibuka', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Tentang Aplikasi'), findsOneWidget);

    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Materi navigasi yang diterapkan'), findsOneWidget);
  });

  testWidgets('item drawer selain Tentang memindahkan tab', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Alamat pengiriman'), findsOneWidget);
    expect(find.text('budi@peukanrumoh.id'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beranda').last);
    await tester.pumpAndSettle();

    expect(find.text('Cari sayur, buah, atau bumbu...'), findsOneWidget);
  });

  testWidgets('alur beli langsung: push dengan data lalu pop dengan data', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Bayam Segar').first);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Beli Langsung'));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan pesanan'), findsOneWidget);
    expect(find.text('Metode pembayaran'), findsOneWidget);

    await tester.tap(find.textContaining('Bayar Rp').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ya, Bayar'));
    await tester.pumpAndSettle();

    expect(find.text('Bayam Segar'), findsOneWidget);
  });

  testWidgets('tambah ke keranjang lalu bayar dari keranjang', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Bayam Segar').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    expect(find.textContaining('masuk keranjang'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Keranjang'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Total Bayar'), findsOneWidget);
    expect(find.textContaining('Bayar Rp'), findsNothing);

    await tester.tap(find.text('Bayar'));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan pesanan'), findsOneWidget);
    expect(find.textContaining('Bayar Rp'), findsOneWidget);
  });

  testWidgets('tab pesanan berpindah kategori', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Pesanan'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pesanan #'), findsWidgets);

    final tabDiproses = find.descendant(
      of: find.byType(TabBar),
      matching: find.text('Diproses'),
    );
    await tester.ensureVisible(tabDiproses);
    await tester.pumpAndSettle();
    await tester.tap(tabDiproses);
    await tester.pumpAndSettle();
    expect(find.text('Pesanan #2401'), findsOneWidget);

    final tabSelesai = find.descendant(
      of: find.byType(TabBar),
      matching: find.text('Selesai'),
    );
    await tester.ensureVisible(tabSelesai);
    await tester.pumpAndSettle();
    await tester.tap(tabSelesai);
    await tester.pumpAndSettle();
    expect(find.text('Pesanan #2310'), findsOneWidget);
  });

  testWidgets('detail pesanan dibuka dari daftar', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Pesanan'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pesanan #2401'));
    await tester.pumpAndSettle();

    expect(find.textContaining('PR-2401'), findsOneWidget);
    expect(find.text('Produk dipesan'), findsOneWidget);
  });

  testWidgets('tombol mode gelap mengubah tema aplikasi', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mode gelap'), findsOneWidget);
    expect(ThemeController.instance.isDark, isFalse);

    await tester.tap(find.text('Mode gelap'));
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isTrue);
    expect(find.text('Nyaman dipakai malam hari'), findsOneWidget);

    await tester.tap(find.text('Mode gelap'));
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isFalse);
    expect(find.text('Tampilan cerah siang hari'), findsOneWidget);
  });
}
