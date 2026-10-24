import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../cubit/keranjang_state.dart';
import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key, this.onLihatProduk});

  final VoidCallback? onLihatProduk;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeranjangCubit, KeranjangState>(
      builder: (context, state) => _isi(context, state),
    );
  }

  Widget _isi(BuildContext context, KeranjangState state) {
    if (state.kosong) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🧺', style: TextStyle(fontSize: 72, color: Colors.grey.shade400)),
            const SizedBox(height: 12),
            Text(
              'Keranjang masih kosong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Yuk pilih kebutuhan dapurmu dulu',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onLihatProduk ??
                  () {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
              child: const Text('Lihat Produk'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: state.item.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, indeks) {
              if (indeks == state.item.length) {
                return TextButton.icon(
                  onPressed: () => context.read<KeranjangCubit>().kosongkan(),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Kosongkan keranjang'),
                  style: TextButton.styleFrom(foregroundColor: Warna.bahaya),
                );
              }
              final item = state.item[indeks];
              return KartuKeranjang(item: item);
            },
          ),
        ),
        _PanelBayar(keranjang: state),
      ],
    );
  }
}

class KartuKeranjang extends StatelessWidget {
  const KartuKeranjang({super.key, required this.item});

  final ItemKeranjang item;

  @override
  Widget build(BuildContext context) {
    final warna = Warna.latarKategori(item.produk.kategori);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                item.produk.emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produk.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  item.produk.labelHarga,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rupiah(item.subtotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Warna.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<KeranjangCubit, KeranjangState>(
            builder: (context, state) {
              final jumlah = state.jumlahUntuk(item.produk);
              return StepperJumlah(
                kecil: true,
                jumlah: jumlah,
                onTambah: () {
                  context.read<KeranjangCubit>().tambah(item.produk);
                },
                onKurangi: () {
                  context.read<KeranjangCubit>().kurangi(item.produk);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PanelBayar extends StatelessWidget {
  const _PanelBayar({required this.keranjang});

  final KeranjangState keranjang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Bayar',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      rupiah(keranjang.totalBayar),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Warna.teal,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Warna.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    final item = List<ItemKeranjang>.from(keranjang.item);
                    final hasil = await Navigator.of(context).pushNamed(
                      AppRoutes.bayar,
                      arguments: ArgumenBayar(item: item),
                    );

                    if (hasil == true) {
                      if (!context.mounted) return;
                      context.read<KeranjangCubit>().kosongkan();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pesanan berhasil dibuat. Terima kasih!'),
                          backgroundColor: Warna.tealTua,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Bayar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
