import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_tugasbank_ayuka/login_screen.dart';
import 'package:flutter_tugasbank_ayuka/data/nasabah_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // Inisialisasi locale 'id'

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NasabahProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Koperasi Undiksha",
      home: LoginScreen(),
    );
  }
}
