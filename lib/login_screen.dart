import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tugasbank_ayuka/models/nasabah.dart';
import 'package:flutter_tugasbank_ayuka/data/nasabah_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String usernameError = '';
  String passwordError = '';

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == "Ayukadw" && password == "2315091018") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      final nasabahProvider = Provider.of<NasabahProvider>(context, listen: false);
      final nasabahBaru = Nasabah(
        nama: "Ni Putu Ayu Kusuma Dewi",
        saldo: 3600000,
        histori: [],
        historiBayar: [],
      );
      nasabahProvider.setNasabah(nasabahBaru);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        usernameError = username != "Ayukadw" ? "Username salah" : '';
        passwordError = password != "2315091018" ? "Password salah" : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png', height: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "Koperasi Undiksha",
                      style: TextStyle(
                        color: cardColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: "Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      errorText: usernameError.isEmpty ? null : usernameError,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      errorText: passwordError.isEmpty ? null : passwordError,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cardColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Daftar Mbanking", style: TextStyle(color: textLightColor))),
                      TextButton(onPressed: () {}, child: const Text("Lupa password?", style: TextStyle(color: textLightColor))),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "© 2025 Ayukadw",
              style: TextStyle(color: textLightColor, fontSize: 14),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
