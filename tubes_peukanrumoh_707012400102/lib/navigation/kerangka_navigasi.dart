import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../cubit/keranjang_state.dart';
import '../halaman/halaman_keranjang.dart';
import '../halaman/halaman_pesanan.dart';
import '../halaman/halaman_profil.dart';
import '../halaman/halaman_utama.dart';
import '../halaman/widget_desain.dart';
import 'app_routes.dart';

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  int _indeks = 0;
  bool _railDiperluas = false;

  static const List<String> _labelTab = [
    'Beranda',
    'Keranjang',
    'Pesanan',
    'Profil',
  ];

  void _pilihTab(int indeks) => setState(() => _indeks = indeks);

  @override
  Widget build(BuildContext context) {
    final layarLebar = MediaQuery.of(context).size.width >= 900;

    return BlocSelector<KeranjangCubit, KeranjangState, int>(
      selector: (state) => state.totalBarang,
      builder: (context, totalBarang) {
        final halaman = [
          HalamanBeranda(denganScaffold: false, totalBarang: totalBarang),
          const HalamanKeranjang(),
          const HalamanPesanan(),
          const HalamanProfil(),
        ];

        return Scaffold(
          drawer: DrawerNavigasi(
            indeksAktif: _indeks,
            onPilihTab: _pilihTab,
            totalBarang: totalBarang,
          ),
          appBar: AppBar(
            title: Text(_labelTab[_indeks]),
            actions: [
              _buildAppBarBadge(totalBarang),
            ],
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (layarLebar) _bangunRail(totalBarang),
                Expanded(
                  child: IndexedStack(index: _indeks, children: halaman),
                ),
              ],
            ),
          ),
          bottomNavigationBar: layarLebar
              ? null
              : _buildNavigationBar(totalBarang),
        );
      },
    );
  }

  Widget _bangunRail(int totalBarang) {
    return NavigationRail(
      selectedIndex: _indeks,
      onDestinationSelected: _pilihTab,
      extended: _railDiperluas,
      labelType: _railDiperluas
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      leading: IconButton(
        tooltip: _railDiperluas ? 'Ciutkan' : 'Perluas',
        icon: const Icon(Icons.menu_open),
        onPressed: () => setState(() => _railDiperluas = !_railDiperluas),
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: Text('Beranda'),
        ),
        NavigationRailDestination(
          icon: Badge(
            isLabelVisible: totalBarang > 0,
            label: BadgeKeranjang(jumlah: totalBarang),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: const Icon(Icons.shopping_cart),
          label: Text('Keranjang'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Pesanan'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profil'),
        ),
      ],
    );
  }

  Widget _buildAppBarBadge(int totalBarang) {
    return IconButton(
      tooltip: 'Keranjang',
      icon: Badge(
        isLabelVisible: totalBarang > 0,
        label: BadgeKeranjang(jumlah: totalBarang),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
      onPressed: () {
        setState(() => _indeks = 1);
      },
    );
  }

  Widget _buildNavigationBar(int totalBarang) {
    return NavigationBar(
      selectedIndex: _indeks,
      onDestinationSelected: _pilihTab,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: totalBarang > 0,
            label: BadgeKeranjang(jumlah: totalBarang),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: const Icon(Icons.shopping_cart),
          label: 'Keranjang',
        ),
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Pesanan',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

class DrawerNavigasi extends StatelessWidget {
  const DrawerNavigasi({
    super.key,
    required this.indeksAktif,
    required this.onPilihTab,
    required this.totalBarang,
  });

  final int indeksAktif;
  final ValueChanged<int> onPilihTab;
  final int totalBarang;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: indeksAktif,
      onDestinationSelected: (indeks) {
        Navigator.of(context).pop();
        onPilihTab(indeks);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Warna.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: Warna.teal,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Peukan Rumoh',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Warna.tealTua,
                      ),
                    ),
                    Text(
                      'Pasar Tradisional Digital',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.storefront_outlined),
          label: Text('Beranda'),
        ),
        NavigationDrawerDestination(
          icon: Badge(
            isLabelVisible: totalBarang > 0,
            label: BadgeKeranjang(jumlah: totalBarang),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          label: const Text('Keranjang'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: Text('Pesanan'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          label: Text('Profil'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoutes.tentang);
          },
        ),
      ],
    );
  }
}
