import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../data/nasabah_provider.dart';
import '../login_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nasabah = Provider.of<NasabahProvider>(context).nasabah;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text('Profil', style: TextStyle(color: cardColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('../assets/DSC05580.png'),
            ),
            const SizedBox(height: 20),
            Text(
              nasabah.nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 4),
            const Text(
              'https://tinyurl.com/ayukadw1018',
              style: TextStyle(fontSize: 14, color: textLightColor),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.person, color: primaryColor),
                title: const Text('Username', style: TextStyle(fontSize: 16, color: textLightColor)),
                subtitle: Text(username, style: const TextStyle(fontSize: 16)),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: accentColor),
                title: const Text('Saldo', style: TextStyle(fontSize: 16, color: textLightColor)),
                subtitle: Text(
                  'Rp ${nasabah.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Logout", style: TextStyle(fontSize: 16, color: Colors.red)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("© 2025 by Ayukadw", style: TextStyle(color: textLightColor)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
