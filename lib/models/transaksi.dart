class Transaksi {
  final String deskripsi;
  final double jumlah;
  final DateTime tanggal;
  final String? catatan; 

  Transaksi({
    required this.deskripsi,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });
}
