import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../models/produk.dart';

class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key});

  String rupiah(int nilai) => 'Rp${nilai.toString()}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeranjangCubit, List<ItemKeranjang>>(
      builder: (context, items) {
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64),
                SizedBox(height: 12),
                Text('Keranjang masih kosong'),
              ],
            ),
          );
        }

        final totalHarga = items.fold<int>(
          0,
          (total, item) => total + (item.produk.harga * item.jumlah),
        );

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, indeks) => const Divider(),
                itemBuilder: (context, indeks) {
                  final item = items[indeks];

                  return ListTile(
                    title: Text(item.produk.nama),
                    subtitle: Text(
                      '${item.jumlah} x ${rupiah(item.produk.harga)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => context
                              .read<KeranjangCubit>()
                              .kurangi(item.produk),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${item.jumlah}'),
                        IconButton(
                          onPressed: () => context
                              .read<KeranjangCubit>()
                              .tambah(item.produk),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: ${rupiah(totalHarga)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.read<KeranjangCubit>().kosongkan(),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Kosongkan Keranjang'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
