import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../cubit/keranjang_state.dart';
import '../cubit/favorit_cubit.dart';
import '../cubit/favorit_state.dart';
import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class DetailProduk extends StatefulWidget {
  const DetailProduk({super.key, required this.produk});

  final ProdukContoh produk;

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  int _jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final warna = Warna.latarKategori(produk.kategori);

    return BlocListener<FavoritCubit, FavoritState>(
      listener: (context, state) {
        if (context.mounted) {
          final isFav = state.favorites.contains(produk.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isFav ? 'Ditambah ke favorit' : 'Dihapus dari favorit'),
              backgroundColor: Warna.tealTua,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: warna,
              foregroundColor: Colors.white,
              title: Text(
                produk.kategori,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: warna.withValues(alpha: 0.9),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          produk.emoji,
                          style: const TextStyle(fontSize: 96),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${produk.penilaian} • ${produk.penjual}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            BlocSelector<FavoritCubit, FavoritState, bool>(
                              selector: (state) => state.favorites.contains(produk.id),
                              builder: (context, isFav) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.white.withValues(alpha: 0.7),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    context.read<FavoritCubit>().toggle(produk.id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk.nama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${produk.labelHarga} / ${produk.satuan}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Warna.teal,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        produk.deskripsi,
                        style: TextStyle(
                          height: 1.5,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              color: Warna.tealTua,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Ongkos kirim flat ke seluruh Banda Aceh',
                              ),
                            ),
                            Text(
                              rupiah(12000),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Warna.tealTua,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Text(
                            'Jumlah',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          StepperJumlah(
                            jumlah: _jumlah,
                            onTambah: () => setState(() => _jumlah++),
                            onKurangi: () =>
                                setState(() => _jumlah = _jumlah > 1 ? _jumlah - 1 : 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<KeranjangCubit, KeranjangState>(
                        builder: (context, state) {
                          final sudahAda = state.items.containsKey(produk.id);
                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: sudahAda ? Warna.teal : Warna.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.bayar,
                                  arguments: ArgumenBayar(
                                    item: [
                                      ItemKeranjang(
                                        produk: produk,
                                        jumlah: _jumlah,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.payments_outlined),
                              label: Text(
                                'Beli Langsung ${rupiah(produk.harga * _jumlah)}',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<KeranjangCubit>().tambah(produk);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${produk.nama} masuk keranjang'),
                                backgroundColor: Warna.tealTua,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Tambah ke Keranjang'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
