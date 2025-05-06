import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/nasabah_provider.dart';
import '../models/transaksi.dart';

class PinjamanPage extends StatefulWidget {
  const PinjamanPage({super.key});

  @override
  State<PinjamanPage> createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final _nominalController = TextEditingController();

  void _ajukanPinjaman(BuildContext context) {
    final double? jumlah = double.tryParse(_nominalController.text.replaceAll(',', '').replaceAll('.', ''));
    if (jumlah == null || jumlah <= 0) {
      _showDialog(context, 'Nominal tidak valid. Masukkan jumlah yang benar.');
      return;
    }

    final formattedJumlah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(jumlah);

    // Dialog konfirmasi
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pinjaman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Anda akan meminjam sejumlah:'),
            const SizedBox(height: 10),
            Text(
              formattedJumlah,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              final nasabahProvider = context.read<NasabahProvider>();
              nasabahProvider.updateSaldo(nasabahProvider.saldo + jumlah);
              nasabahProvider.tambahTransaksi(Transaksi(
                deskripsi: 'Pinjaman Masuk',
                jumlah: jumlah,
                tanggal: DateTime.now(),
              ));

              Navigator.pop(context);
              _showDialog(context, 'Pinjaman berhasil ditambahkan ke saldo.');
              _nominalController.clear();
            },
            child: const Text('Ya, Lanjutkan', style: TextStyle(color: cardColor)),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String pesan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Informasi'),
        content: Text(pesan),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saldo = context.watch<NasabahProvider>().saldo;
    final formattedSaldo = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(saldo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Pinjaman', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo Anda', style: TextStyle(fontSize: 14, color: textLightColor)),
            const SizedBox(height: 4),
            Text(
              formattedSaldo,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal Pinjaman',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _ajukanPinjaman(context),
                icon: const Icon(Icons.attach_money),
                label: const Text('Ajukan Pinjaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cardColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
