import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/nasabah_provider.dart';
import '../models/transaksi.dart';

class MutasiPage extends StatelessWidget {
  MutasiPage({super.key});

  final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id');

  @override
  Widget build(BuildContext context) {
    final histori = context.watch<NasabahProvider>().nasabah.histori.reversed.toList();
    final pemasukan = histori.where((t) => t.jumlah > 0).toList();
    final pengeluaran = histori.where((t) => t.jumlah < 0).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("Mutasi Transaksi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor)),
          centerTitle: true,
          backgroundColor: primaryColor,
          bottom: const TabBar(
            labelColor: cardColor,
            unselectedLabelColor: textLightColor,
            indicatorColor: accentColor,
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Pemasukan"),
              Tab(text: "Pengeluaran"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(histori, context),
            _buildList(pemasukan, context),
            _buildList(pengeluaran, context),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Transaksi> data, BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text("Belum ada transaksi", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final transaksi = data[index];
        final isDebit = transaksi.jumlah < 0;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: isDebit ? Colors.red[100] : Colors.green[100],
              child: Icon(
                isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                color: isDebit ? Colors.red : Colors.green,
              ),
            ),
            title: Text(
              transaksi.deskripsi,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dateFormat.format(transaksi.tanggal)),
            trailing: Text(
              currencyFormat.format(transaksi.jumlah),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDebit ? Colors.red : Colors.green,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
