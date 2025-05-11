import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/pages/pembayaran_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/profile_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/scanqr_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/setting_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/cek_saldo_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/deposito_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/mutasi_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/pinjaman_page.dart';
import 'package:flutter_tugasbank_ayuka/pages/transfer_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tugasbank_ayuka/data/nasabah_provider.dart';
import 'package:intl/intl.dart';

const Color primaryColor = Color(0xFF0D47A1); // Biru Tua
const Color accentColor = Color(0xFFF4C430);  // Emas Muda
const Color backgroundColor = Color.fromARGB(255, 238, 245, 255); // Abu biru Muda
const Color cardColor = Color(0xFFFFFFFF); // Putih
const Color textLightColor = Color(0xFF757575); // Abu-abu Tua

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final nasabah = Provider.of<NasabahProvider>(context).nasabah;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, backgroundColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        bottomOpacity: 0.1,
        elevation: 0,
        title: const Text(
          "Koperasi Undiksha",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cardColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Kartu informasi saldo
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("../assets/DSC05580.png"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nasabah.nama,
                                style: const TextStyle(
                                    color: cardColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            const Text("Total Saldo",
                                style: TextStyle(color: Colors.white70)),
                            Text(currencyFormat.format(nasabah.saldo),
                                style: const TextStyle(
                                    color: cardColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Deposito: ${currencyFormat.format(nasabah.deposito)}",
                                style: const TextStyle(color: accentColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // Grid Menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildMenuItem(Icons.account_balance_wallet, "Cek Saldo", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CekSaldoPage()));
                      }),
                      _buildMenuItem(Icons.send, "Transfer", () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => TransferPage()));
                        setState(() {});
                      }),
                      _buildMenuItem(Icons.savings, "Deposito", () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => DepositoPage()));
                        setState(() {});
                      }),
                      _buildMenuItem(Icons.payment, "Pembayaran", () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => PembayaranPage()));
                        setState(() {});
                      }),
                      _buildMenuItem(Icons.attach_money, "Pinjaman", () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => PinjamanPage()));
                        setState(() {});
                      }),
                      _buildMenuItem(Icons.history, "Mutasi", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MutasiPage()));
                      }),
                    ],
                  ),
                ),

                // Bantuan
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.phone, color: accentColor, size: 40),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Butuh Bantuan?", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("0857-8497-8009", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom navigation custom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomMenu(Icons.settings, "Setting", SettingPage()),
                _buildBottomMenu(Icons.qr_code_scanner, "Scan QR", ScanQRPage()),
                _buildBottomMenu(Icons.person, "Profile", ProfilePage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color.fromARGB(30, 0, 0, 0),
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: primaryColor),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMenu(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        setState(() {});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: primaryColor),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
