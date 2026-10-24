import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../bloc/pengajuan_bloc.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_warga.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  static const double _ambangLebar = 600;

  final List<Widget> _halaman = const [
    HalamanBeranda(),
    HalamanLayanan(),
    HalamanWarga(),
  ];

  final List<_TujuanUtama> _tujuan = const [
    _TujuanUtama(
      label: 'Beranda',
      ikon: Icons.dashboard_outlined,
      ikonAktif: Icons.dashboard,
    ),
    _TujuanUtama(
      label: 'Layanan',
      ikon: Icons.apps_outlined,
      ikonAktif: Icons.apps,
    ),
    _TujuanUtama(
      label: 'Warga',
      ikon: Icons.person_outline,
      ikonAktif: Icons.person,
      // Hanya tujuan Warga yang membawa badge jumlah pengajuan.
      tampilkanBadge: true,
    ),
  ];

  void _pilihTujuan(int indeks) {
    setState(() => _indeksTerpilih = indeks);
  }

  @override
  Widget build(BuildContext context) {
    final double lebar = MediaQuery.of(context).size.width;
    final bool layarLebar = lebar >= _ambangLebar;

    return Scaffold(
      // Tanpa AppBar: halaman sudah membawa judul section-nya sendiri
      // sehingga tampilan lebih bersih dan tidak dobel header.
      drawer: _buatDrawer(context),
      // Pada layar sempit dipasang header ramping berisi tombol menu agar
      // NavigationDrawer tetap mudah dijangkau tanpa AppBar penuh.
      body: layarLebar
          ? _tataLetakLebar()
          : Builder(
              builder: (konteksScaffold) => Column(
                children: [
                  _HeaderRamping(
                    onBukaDrawer: () =>
                        Scaffold.of(konteksScaffold).openDrawer(),
                  ),
                  Expanded(child: _halaman[_indeksTerpilih]),
                ],
              ),
            ),
      bottomNavigationBar: layarLebar ? null : _buatBilahBawah(),
    );
  }

  Widget _buatBilahBawah() {
    return NavigationBar(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      destinations: _tujuan
          .map(
            (t) => NavigationDestination(
              icon: _ikonTujuan(t),
              selectedIcon: _ikonTujuan(t, aktif: true),
              label: t.label,
            ),
          )
          .toList(),
    );
  }

  Widget _tataLetakLebar() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          extended: true,
          minExtendedWidth: 200,
          leading: const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NUSANTARA',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppTheme.tekstUtama,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'CERDAS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppTheme.aksen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          destinations: _tujuan
              .map(
                (t) => NavigationRailDestination(
                  icon: _ikonTujuan(t),
                  selectedIcon: _ikonTujuan(t, aktif: true),
                  label: Text(t.label),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: _halaman[_indeksTerpilih]),
      ],
    );
  }

  Widget _buatDrawer(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: (indeks) {
        _pilihTujuan(indeks);
        Navigator.pop(context);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NUSANTARA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppTheme.tekstUtama,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'CERDAS',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppTheme.aksen,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Layanan Warga Kota Nusantara',
                style: TextStyle(fontSize: 12.5, color: AppTheme.tekstSekunder),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ..._tujuan.map(
          (t) => NavigationDrawerDestination(
            icon: _ikonTujuan(t),
            selectedIcon: _ikonTujuan(t, aktif: true),
            label: Text(t.label),
          ),
        ),
      ],
    );
  }

  /// Ikon tujuan dengan badge bila diperlukan. Dipakai di NavigationBar,
  /// NavigationRail, dan NavigationDrawer.
  Widget _ikonTujuan(_TujuanUtama t, {bool aktif = false}) {
    if (!t.tampilkanBadge) {
      return Icon(aktif ? t.ikonAktif : t.ikon);
    }
    // select Detached-only: hanya widget kecil ini yang rebuild saat jumlah
    // pengajuan berubah, bukan seluruh kerangka navigasi.
    return _IkonDenganBadge(
      aktif: aktif,
      ikon: t.ikon,
      ikonAktif: t.ikonAktif,
    );
  }
}

class _IkonDenganBadge extends StatelessWidget {
  const _IkonDenganBadge({
    required this.aktif,
    required this.ikon,
    required this.ikonAktif,
  });

  final bool aktif;
  final IconData ikon;
  final IconData ikonAktif;

  @override
  Widget build(BuildContext context) {
    final total = context.select<PengajuanBloc, int>((state) => state.totalPengajuan);

    return Badge(
      isLabelVisible: total > 0,
      label: Text('$total'),
      backgroundColor: AppTheme.aksen,
      textColor: Colors.white,
      child: Icon(aktif ? ikonAktif : ikon),
    );
  }
}

/// Header ramping di atas konten (layar sempit): tombol menu pembuka
/// drawer plus wordmark kecil. Pengganti AppBar tanpa memakan tinggi.
class _HeaderRamping extends StatelessWidget {
  const _HeaderRamping({required this.onBukaDrawer});

  final VoidCallback onBukaDrawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.garis)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Buka menu',
                icon: const Icon(Icons.menu, size: 22),
                onPressed: onBukaDrawer,
              ),
              const Text(
                'NUSANTARA',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                  color: AppTheme.tekstUtama,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'CERDAS',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                  color: AppTheme.aksen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TujuanUtama {
  const _TujuanUtama({
    required this.label,
    required this.ikon,
    required this.ikonAktif,
    this.tampilkanBadge = false,
  });

  final String label;
  final IconData ikon;
  final IconData ikonAktif;
  final bool tampilkanBadge;
}
