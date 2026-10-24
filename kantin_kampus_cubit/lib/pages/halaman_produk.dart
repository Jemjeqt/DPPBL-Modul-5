import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/keranjang_cubit.dart';
import '../models/produk.dart';

class HalamanProduk extends StatelessWidget {
  const HalamanProduk({super.key});

  static const daftarProduk = [
    Produk(nama: 'Nasi Goreng', harga: 15000, ikon: '🍛'),
    Produk(nama: 'Mie Ayam', harga: 13000, ikon: '🍜'),
    Produk(nama: 'Es Teh', harga: 5000, ikon: '🧋'),
  ];

  String rupiah(int nilai) => 'Rp${nilai.toString()}';

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: daftarProduk.length,
      separatorBuilder: (context, indeks) => const SizedBox(height: 8),
      itemBuilder: (context, indeks) {
        final produk = daftarProduk[indeks];

        return Card(
          child: ListTile(
            leading: Text(produk.ikon, style: const TextStyle(fontSize: 32)),
            title: Text(produk.nama),
            subtitle: Text(rupiah(produk.harga)),
            trailing: FilledButton(
              onPressed: () {
                context.read<KeranjangCubit>().tambah(produk);
              },
              child: const Text('Tambah'),
            ),
          ),
        );
      },
    );
  }
}
