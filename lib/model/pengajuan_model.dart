import 'package:flutter/foundation.dart';

/// Data satu pengajuan layanan warga.
class Pengajuan {
  Pengajuan({
    required this.id,
    required this.nama,
    required this.email,
    required this.bidang,
    required this.sesi,
    required this.tanggal,
    this.selesai = false,
  });

  final String id;
  final String nama;
  final String email;
  final String bidang;
  final String sesi;
  final DateTime tanggal;
  bool selesai;
}

/// State bersama untuk riwayat pengajuan dan statistiknya.
class PengajuanModel extends ChangeNotifier {
  final List<Pengajuan> _daftarPengajuan = [];

  static const List<String> bidangLayanan = [
    'Administrasi Kependudukan',
    'Perizinan',
    'Kesehatan',
    'Pendidikan',
  ];

  List<Pengajuan> get daftarPengajuan =>
      List<Pengajuan>.unmodifiable(_daftarPengajuan);

  int get jumlahPengajuan => _daftarPengajuan.length;

  int get jumlahSelesai =>
      _daftarPengajuan.where((pengajuan) => pengajuan.selesai).length;

  int get jumlahDalamProses => jumlahPengajuan - jumlahSelesai;

  Map<String, int> get statistikPerBidang {
    return {
      for (final bidang in bidangLayanan)
        bidang: _daftarPengajuan
            .where((pengajuan) => pengajuan.bidang == bidang)
            .length,
    };
  }

  Pengajuan? cariPengajuan(String id) {
    for (final pengajuan in _daftarPengajuan) {
      if (pengajuan.id == id) return pengajuan;
    }
    return null;
  }

  void tambahPengajuan({
    required String nama,
    required String email,
    required String bidang,
    required String sesi,
  }) {
    final pengajuan = Pengajuan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nama: nama.trim(),
      email: email.trim(),
      bidang: bidang,
      sesi: sesi,
      tanggal: DateTime.now(),
    );
    _daftarPengajuan.insert(0, pengajuan);
    notifyListeners();
  }

  void tandaiSelesai(String id) {
    final pengajuan = cariPengajuan(id);
    if (pengajuan == null || pengajuan.selesai) return;

    pengajuan.selesai = true;
    notifyListeners();
  }
}
