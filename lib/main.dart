import 'package:flutter/material.dart';
import 'package:flutter_tugasbank_ayuka/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Koperasi Undiksha",
      home: LoginScreen(),
    );
  }
}