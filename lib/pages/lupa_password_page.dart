import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/home_screen.dart';

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;

  void _sendOtp() {
    // Simulasi kirim OTP
    setState(() => _otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kode OTP telah dikirim")),
    );
  }

  void _verifyOtp() {
    // Simulasi verifikasi OTP
    if (_otpController.text == "123456") {
      setState(() => _otpVerified = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP salah")),
      );
    }
  }

  void _changePassword() {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak cocok")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Password berhasil diganti."),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: primaryColor)),
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke login
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cardColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_otpSent) ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email atau Nomor HP",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Kirim Kode OTP", style: TextStyle(color: cardColor)),
                  ),
                ),
              ] else if (!_otpVerified) ...[
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: "Masukkan Kode OTP",
                    prefixIcon: Icon(Icons.security),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Verifikasi OTP", style: TextStyle(color: cardColor)),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password Baru",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Ganti Password", style: TextStyle(color: cardColor)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
