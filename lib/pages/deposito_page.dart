import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/nasabah_provider.dart';
import '../models/deposito.dart';
import '../models/transaksi.dart';

class DepositoPage extends StatefulWidget {
  const DepositoPage({super.key});

  @override
  State<DepositoPage> createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  final _jumlahController = TextEditingController();
  final _tokenController = TextEditingController();

  final double bungaTahunan = 4.5; // Contoh bunga
  int _selectedDuration = 1; // default 1 bulan

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NasabahProvider>().nasabah.cekDanCairkanDeposito();
      setState(() {});
    });
  }

  void _depositSaldo(BuildContext context) {
    final jumlah = double.tryParse(_jumlahController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0;
    final token = _tokenController.text.trim();

    if (jumlah <= 0 || token.isEmpty) {
      _showDialog('Jumlah deposito atau token tidak valid');
      return;
    }

    if (token != '2315091018') {
      _showDialog('Token salah. Silakan coba lagi.');
      return;
    }

    final now = DateTime.now();
    final jatuhTempo = DateTime(now.year, now.month + _selectedDuration, now.day);
    final bunga = jumlah * (bungaTahunan / 100) * (_selectedDuration / 12);
    final totalAkhir = jumlah + bunga;

    final formattedJumlah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(jumlah);
    final formattedAkhir = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalAkhir);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Deposito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Setor: $formattedJumlah'),
            Text('Durasi: $_selectedDuration bulan'),
            Text('Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(jatuhTempo)}'),
            Text('Bunga/Tahun: $bungaTahunan%'),
            Text('Estimasi Hasil Akhir: $formattedAkhir'),
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
              final provider = context.read<NasabahProvider>();
              provider.tambahDeposito(Deposito(
                jumlah: jumlah,
                tanggalMulai: now,
                tanggalJatuhTempo: jatuhTempo,
                bungaTahunan: bungaTahunan,
              ));
              provider.tambahTransaksi(Transaksi(
                deskripsi: "Setor Deposito",
                jumlah: jumlah,
                tanggal: now,
              ));
              Navigator.pop(context);
              _showDialog('Deposito berhasil sejumlah $formattedJumlah\n(Jatuh tempo: ${DateFormat('dd MMM yyyy').format(jatuhTempo)})');
              _jumlahController.clear();
              _tokenController.clear();
              setState(() {});
            },
            child: const Text('Ya, Setor', style: TextStyle(color: cardColor)),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
    final saldo = context.watch<NasabahProvider>().nasabah.saldo;
    final formattedSaldo = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2).format(saldo);
    final depositoList = context.watch<NasabahProvider>().nasabah.daftarDeposito;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposito', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saldo Anda', style: TextStyle(color: textLightColor)),
                    const SizedBox(height: 4),
                    Text(formattedSaldo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bunga per tahun', style: TextStyle(fontSize: 16)),
                        Text('$bungaTahunan%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Deposito',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: _selectedDuration,
              decoration: InputDecoration(
                labelText: 'Jangka Waktu (bulan)',
                prefixIcon: const Icon(Icons.timer),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [1, 3, 6, 12]
                  .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text('$val bulan'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() {
                _selectedDuration = val ?? 1;
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Token',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _depositSaldo(context),
                icon: const Icon(Icons.savings, color: cardColor),
                label: const Text('Setor Sekarang', style: TextStyle(color: cardColor, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (depositoList.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Text('Daftar Deposito Aktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...depositoList.map((d) {
                final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Nominal: ${formatter.format(d.jumlah)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mulai: ${DateFormat('dd MMM yyyy').format(d.tanggalMulai)}'),
                        Text('Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(d.tanggalJatuhTempo)}'),
                        Text('Bunga: ${d.bungaTahunan}%'),
                        Text('Total Akhir: ${formatter.format(d.hasilAkhir)}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ]
          ],
        ),
      ),
    );
  }
}
