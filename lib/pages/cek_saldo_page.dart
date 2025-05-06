import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/nasabah_provider.dart';

class CekSaldoPage extends StatelessWidget {
  final format = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final nasabahProvider = Provider.of<NasabahProvider>(context);
    final saldo = nasabahProvider.nasabah.saldo;
    final deposito = nasabahProvider.nasabah.deposito;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Saldo', style: TextStyle(color: cardColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, size: 48, color: cardColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Total Saldo Anda',
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      format.format(saldo),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.savings, size: 48, color: cardColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Total Deposito Anda',
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      format.format(deposito),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
