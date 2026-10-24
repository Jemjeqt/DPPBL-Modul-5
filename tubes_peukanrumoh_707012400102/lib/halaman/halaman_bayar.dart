import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class HalamanBayar extends StatefulWidget {
  const HalamanBayar({super.key, required this.argumen});

  final ArgumenBayar argumen;

  @override
  State<HalamanBayar> createState() => _HalamanBayarState();
}

class _HalamanBayarState extends State<HalamanBayar> {
  String _metode = 'Transfer Bank';

  static const _metodeList = [
    (nama: 'Transfer Bank', ikon: Icons.account_balance_outlined, ket: 'BCA, BSI, Mandiri'),
    (nama: 'COD', ikon: Icons.local_shipping_outlined, ket: 'Bayar saat barang tiba'),
    (nama: 'E-Wallet', ikon: Icons.account_balance_wallet_outlined, ket: 'Dana, OVO, GoPay'),
  ];

  @override
  Widget build(BuildContext context) {
    final argumen = widget.argumen;

    return Scaffold(
      appBar: AppBar(title: const Text('Bayar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Ringkasan pesanan',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final item in argumen.item)
            KartuItemPesanan(item: item),
          if (argumen.item.isEmpty)
            const Text('Tidak ada item untuk dibayar.'),
          const SizedBox(height: 16),
          Text('Metode pembayaran',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final metode in _metodeList)
            _KartuMetode(
              nama: metode.nama,
              keterangan: metode.ket,
              ikon: metode.ikon,
              dipilih: _metode == metode.nama,
              onTap: () => setState(() => _metode = metode.nama),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _baris(context, 'Alamat', profilContoh.alamat),
                _baris(context, 'Subtotal', rupiah(argumen.totalHarga)),
                _baris(context, 'Ongkir', rupiah(argumen.ongkir)),
                const Divider(height: 16),
                Row(
                  children: [
                    const Text('Total',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(
                      rupiah(argumen.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Warna.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Warna.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: argumen.item.isEmpty
                ? null
                : () {
                    _konfirmasi(context, argumen.total, _metode);
                  },
            icon: const Icon(Icons.lock_outline),
            label: Text('Bayar ${rupiah(argumen.total)}'),
          ),
        ),
      ),
    );
  }

  Widget _baris(BuildContext context, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
          const Spacer(),
          Flexible(
            child: Text(
              nilai,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasi(BuildContext context, int total, String metode) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text('Bayar ${rupiah(total)} via $metode?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Warna.teal),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text('Ya, Bayar'),
          ),
        ],
      ),
    );
  }
}

class _KartuMetode extends StatelessWidget {
  const _KartuMetode({
    required this.nama,
    required this.keterangan,
    required this.ikon,
    required this.dipilih,
    required this.onTap,
  });

  final String nama;
  final String keterangan;
  final IconData ikon;
  final bool dipilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: dipilih ? Warna.tealMuda : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dipilih ? Warna.teal : Theme.of(context).dividerColor.withValues(alpha: 0.4),
              width: dipilih ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                ikon,
                color: dipilih ? Warna.tealTua : Theme.of(context).hintColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      keterangan,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                dipilih ? Icons.check_circle : Icons.radio_button_off,
                color: dipilih ? Warna.teal : Theme.of(context).hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
