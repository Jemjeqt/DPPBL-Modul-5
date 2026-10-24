import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../cubit/keranjang_state.dart';
import '../cubit/favorit_cubit.dart';
import '../cubit/favorit_state.dart';
import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({
    super.key,
    this.denganScaffold = true,
    this.totalBarang = 0,
  });

  final bool denganScaffold;
  final int totalBarang;

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  String _kataKunci = '';
  String _kategoriDipilih = '';

  List<ProdukContoh> get _hasilFilter {
    return daftarProdukContoh.where((produk) {
      if (_kategoriDipilih.isNotEmpty && produk.kategori != _kategoriDipilih) {
        return false;
      }
      if (_kataKunci.isNotEmpty &&
          !produk.nama.toLowerCase().contains(_kataKunci.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _heroBand() {
    final jam = DateTime.now().hour;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Warna.tealTua, Warna.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jam < 11
                      ? 'Pagi, mau beli apa?'
                      : jam < 15
                          ? 'Siang, mau beli apa?'
                          : 'Sore, mau beli apa?',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Belanja kebutuhan dapur\ndari peukan Aceh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.keranjang),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Badge(
                isLabelVisible: widget.totalBarang > 0,
                label: BadgeKeranjang(jumlah: widget.totalBarang),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isi = Column(
      children: [
        _heroBand(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari sayur, buah, atau bumbu...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (nilai) => setState(() => _kataKunci = nilai),
          ),
        ),
        SizedBox(
          height: 86,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            children: [
              for (final kategori in daftarKategori)
                _KategoriBulat(
                  kategori: kategori,
                  dipilih: _kategoriDipilih == kategori,
                  onTap: () => setState(() => _kategoriDipilih = kategori),
                ),
            ],
          ),
        ),
        Expanded(
          child: _hasilFilter.isEmpty
              ? _KondisiKosongPencarian(
                  onReset: () => setState(() {
                    _kataKunci = '';
                    _kategoriDipilih = '';
                  }),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final lebar = constraints.maxWidth;
                    final kolom = lebar >= 900
                        ? 4
                        : lebar >= 600
                            ? 3
                            : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: kolom,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _hasilFilter.length,
                      itemBuilder: (context, indeks) {
                        return KartuProdukBaru(
                          produk: _hasilFilter[indeks],
                          totalBarang: widget.totalBarang,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );

    if (!widget.denganScaffold) return isi;

    return Scaffold(
      appBar: AppBar(title: const Text('Peukan Rumoh')),
      body: isi,
    );
  }
}

class _KategoriBulat extends StatelessWidget {
  const _KategoriBulat({
    required this.kategori,
    required this.dipilih,
    required this.onTap,
  });

  final String kategori;
  final bool dipilih;
  final VoidCallback onTap;

  IconData get _ikon {
    switch (kategori) {
      case 'Sayuran':
        return Icons.eco_outlined;
      case 'Buah':
        return Icons.emoji_nature;
      case 'Daging':
        return Icons.kebab_dining_outlined;
      case 'Ikan':
        return Icons.set_meal_outlined;
      case 'Bumbu':
        return Icons.local_fire_department_outlined;
      case 'Sembako':
        return Icons.grain;
      default:
        return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    final warna = kategori == 'Semua' ? Warna.teal : Warna.latarKategori(kategori);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: dipilih ? warna : warna.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: dipilih
                    ? Border.all(color: warna, width: 2)
                    : null,
              ),
              child: Icon(
                _ikon,
                color: dipilih ? Colors.white : warna,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              kategori,
              style: TextStyle(
                fontSize: 11,
                fontWeight: dipilih ? FontWeight.w700 : FontWeight.w500,
                color: dipilih ? warna : Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KartuProdukBaru extends StatelessWidget {
  const KartuProdukBaru({
    super.key,
    required this.produk,
    this.totalBarang = 0,
  });

  final ProdukContoh produk;
  final int totalBarang;

  @override
  Widget build(BuildContext context) {
    final warna = Warna.latarKategori(produk.kategori);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.produk,
            arguments: ArgumenProduk(produk: produk),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: warna.withValues(alpha: 0.10),
                    child: Center(
                      child: Text(
                        produk.emoji,
                        style: const TextStyle(fontSize: 46),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: warna,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        produk.kategori,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocSelector<FavoritCubit, FavoritState, bool>(
                      selector: (state) => state.favorites.contains(produk.id),
                      builder: (context, isFav) => IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                        onPressed: () {
                          context.read<FavoritCubit>().toggle(produk.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'per ${produk.satuan}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          produk.labelHarga,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Warna.teal,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: BlocBuilder<KeranjangCubit, KeranjangState>(
                          builder: (context, state) {
                            final sudahAda = state.items.containsKey(produk.id);
                            return IconButton(
                              tooltip: 'Tambah ke keranjang',
                              style: IconButton.styleFrom(
                                backgroundColor: sudahAda ? Warna.teal : Warna.teal,
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                sudahAda ? Icons.check : Icons.add,
                                size: 18,
                              ),
                              onPressed: () {
                                if (sudahAda) {
                                  context.read<KeranjangCubit>().hapus(produk.id);
                                } else {
                                  context.read<KeranjangCubit>().tambah(produk);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KondisiKosongPencarian extends StatelessWidget {
  const _KondisiKosongPencarian({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 12),
          const Text('Produk tidak ditemukan'),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onReset, child: const Text('Reset pencarian')),
        ],
      ),
    );
  }
}
