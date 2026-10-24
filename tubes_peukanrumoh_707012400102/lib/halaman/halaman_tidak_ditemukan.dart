import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'widget_desain.dart';

class HalamanTidakDitemukan extends StatelessWidget {
  const HalamanTidakDitemukan({super.key, this.namaRoute});

  final String? namaRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🧭',
                style: TextStyle(
                  fontSize: 72,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Warna.tealTua,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                namaRoute == null
                    ? 'Route yang dituju tidak dikenal.'
                    : 'Route "$namaRoute" tidak terdaftar di app_routes.dart.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Warna.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.beranda, (r) => false);
                },
                icon: const Icon(Icons.storefront),
                label: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
