import 'package:flutter/foundation.dart';
import '../models/nasabah.dart';
import '../models/transaksi.dart';
import '../models/deposito.dart';

class NasabahProvider extends ChangeNotifier {
  late Nasabah _nasabah;

  Nasabah get nasabah => _nasabah;
  double get saldo => _nasabah.saldo;

  NasabahProvider() {
    // Inisialisasi awal
    _nasabah = Nasabah(
      nama: "Ni Putu Ayu Kusuma Dewi",
      saldo: 3600000,
      histori: [],
      historiBayar: [],
    );
  }

  void updateSaldo(double baru) {
    _nasabah.saldo = baru;
    notifyListeners();
  }

  void tambahTransaksi(Transaksi transaksi) {
    _nasabah.tambahTransaksi(transaksi);
    notifyListeners();
  }

  void tambahPembayaran(Transaksi transaksi) {
    _nasabah.tambahPembayaran(transaksi);
    notifyListeners();
  }

  void tambahDeposito(Deposito deposito) {
    _nasabah.tambahDeposito(deposito);
    notifyListeners();
  }

  void setNasabah(Nasabah nasabahBaru) {
    _nasabah = nasabahBaru;
    notifyListeners();
  }
}
