class Deposito {
  double jumlah;
  DateTime tanggalMulai;
  DateTime tanggalJatuhTempo;
  double bungaTahunan;

  Deposito({
    required this.jumlah,
    required this.tanggalMulai,
    required this.tanggalJatuhTempo,
    required this.bungaTahunan,
  });

  double get hasilAkhir {
    final durasiHari = tanggalJatuhTempo.difference(tanggalMulai).inDays;
    final bunga = jumlah * (bungaTahunan / 100) * (durasiHari / 365);
    return jumlah + bunga;
  }

  bool get sudahJatuhTempo => DateTime.now().isAfter(tanggalJatuhTempo);
}
