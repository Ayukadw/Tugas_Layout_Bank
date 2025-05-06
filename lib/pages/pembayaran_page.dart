import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/nasabah_provider.dart';
import '../models/transaksi.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _nominalController = TextEditingController();
  final _tujuanLainController = TextEditingController();
  String? _selectedTujuan;

  final List<String> _tujuanPembayaran = [
    'PDAM',
    'PLN',
    'Internet',
    'Telepon',
    'Lainnya',
  ];

  void _konfirmasiPembayaran(BuildContext context, double jumlah) {
    final formattedJumlah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(jumlah);

    final tujuan = _selectedTujuan == 'Lainnya'
        ? _tujuanLainController.text.trim()
        : _selectedTujuan;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Anda akan melakukan pembayaran untuk:"),
            const SizedBox(height: 6),
            Text(
              tujuan ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Sebesar:"),
            const SizedBox(height: 6),
            Text(
              formattedJumlah,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", 
                  style: TextStyle(color: primaryColor))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              final provider = context.read<NasabahProvider>();
              provider.updateSaldo(provider.saldo - jumlah);
              provider.tambahPembayaran(Transaksi(
                deskripsi: "Pembayaran $tujuan",
                jumlah: -jumlah,
                tanggal: DateTime.now(),
              ));
              Navigator.pop(context);
              _showDialog(context, "Pembayaran berhasil!");
              _nominalController.clear();
              _tujuanLainController.clear();
              setState(() => _selectedTujuan = null);
            },
            child: const Text("Ya, Bayar", 
                style: TextStyle(color: cardColor)),
          ),
        ],
      ),
    );
  }

  void _bayar(BuildContext context) {
    final provider = context.read<NasabahProvider>();
    final saldo = provider.saldo;

    final double? jumlah = double.tryParse(
      _nominalController.text.replaceAll(',', '').replaceAll('.', ''),
    );

    if (jumlah == null || jumlah <= 0) {
      _showDialog(context, "Nominal tidak valid.");
      return;
    }

    if (jumlah > saldo) {
      _showDialog(context, "Saldo tidak cukup untuk melakukan pembayaran.");
      return;
    }

    if (_selectedTujuan == null || _selectedTujuan!.isEmpty) {
      _showDialog(context, "Silakan pilih tujuan pembayaran terlebih dahulu.");
      return;
    }

    if (_selectedTujuan == 'Lainnya' &&
        _tujuanLainController.text.trim().isEmpty) {
      _showDialog(context, "Silakan isi tujuan pembayaran Anda.");
      return;
    }

    _konfirmasiPembayaran(context, jumlah);
  }

  void _showDialog(BuildContext context, String pesan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Informasi"),
        content: Text(pesan),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saldo = context.watch<NasabahProvider>().saldo;
    final formattedSaldo =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(saldo);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo Anda',
                style: TextStyle(fontSize: 14, color: textLightColor)),
            const SizedBox(height: 4),
            Text(
              formattedSaldo,
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedTujuan,
              hint: const Text('Pilih Tujuan Pembayaran'),
              items: _tujuanPembayaran.map((tujuan) {
                return DropdownMenuItem<String>(
                  value: tujuan,
                  child: Text(tujuan),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTujuan = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedTujuan == 'Lainnya') ...[
              TextField(
                controller: _tujuanLainController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Tujuan Pembayaran',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal Pembayaran',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _bayar(context),
                icon: const Icon(Icons.payment, color: cardColor),
                label: const Text('Bayar Sekarang', 
                    style: TextStyle(color: cardColor, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}