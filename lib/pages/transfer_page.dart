import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/nasabah_provider.dart';
import '../models/transaksi.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _rekeningController = TextEditingController();
  final _jumlahController = TextEditingController();

  void _transferSaldo(BuildContext context) {
    final saldo = context.read<NasabahProvider>().saldo;
    final rekening = _rekeningController.text.trim();
    final jumlah = double.tryParse(
          _jumlahController.text.replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;

    if (rekening.isEmpty || jumlah <= 0) {
      _showDialog('Nomor rekening atau jumlah transfer tidak valid');
      return;
    }

    if (jumlah > saldo) {
      _showDialog('Saldo Anda tidak cukup untuk transfer ini.');
      return;
    }

    final formattedJumlah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(jumlah);

    // Konfirmasi transfer
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Apakah Anda yakin ingin mentransfer:'),
            const SizedBox(height: 8),
            Text(
              formattedJumlah,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('ke rekening: $rekening'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<NasabahProvider>().updateSaldo(saldo - jumlah);

              context.read<NasabahProvider>().tambahTransaksi(
                Transaksi(
                  deskripsi: 'Transfer ke $rekening',
                  jumlah: -jumlah,
                  tanggal: DateTime.now(),
                ),
              );

              Navigator.pop(context);
              _showDialog('Transfer berhasil ke rekening $rekening sejumlah $formattedJumlah');
              _rekeningController.clear();
              _jumlahController.clear();
            },
            child: const Text('Ya, Transfer', 
                style: TextStyle(color: cardColor, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Informasi'),
        content: Text(message),
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
        title: const Text('Transfer Saldo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo Anda', style: TextStyle(color: textLightColor)),
                  const SizedBox(height: 4),
                  Text(
                    formattedSaldo,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _rekeningController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nomor Rekening Tujuan',
                prefixIcon: const Icon(Icons.account_balance),
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Transfer',
                prefixIcon: const Icon(Icons.money_outlined),
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _transferSaldo(context),
                icon: const Icon(Icons.send_rounded, color: cardColor),
                label: const Text('Transfer', style: TextStyle(color: cardColor, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}