import 'transaksi.dart';
import 'deposito.dart';

class Nasabah {
  final String nama;
  double saldo;
  double deposito;
  List<Transaksi> histori;
  List<Transaksi> historiBayar;
  List<Deposito> daftarDeposito;

  Nasabah({
    required this.nama,
    required this.saldo,
    List<Transaksi>? histori,
    List<Transaksi>? historiBayar,
    this.deposito = 0,
    List<Deposito>? daftarDeposito,
  })  : histori = histori ?? [],
        historiBayar = historiBayar ?? [],
        daftarDeposito = daftarDeposito ?? [];

  void tambahTransaksi(Transaksi transaksi) {
    histori.add(transaksi);
  }

  void tambahPembayaran(Transaksi transaksi) {
    historiBayar.add(transaksi);
    histori.add(transaksi); // agar tercatat juga di mutasi
  }

  void tambahDeposito(Deposito d) {
    deposito += d.jumlah;
    daftarDeposito.add(d);
  }

  void cekDanCairkanDeposito() {
    final yangSudahJatuhTempo = daftarDeposito.where((d) => d.sudahJatuhTempo).toList();
    for (var d in yangSudahJatuhTempo) {
      saldo += d.hasilAkhir;
      histori.add(Transaksi(
        deskripsi: "Pencairan Deposito + Bunga",
        jumlah: d.hasilAkhir,
        tanggal: DateTime.now(),
      ));
      deposito -= d.jumlah;
      daftarDeposito.remove(d);
    }
  }
}
