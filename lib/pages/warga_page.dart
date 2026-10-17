import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';
import '../navigation/app_routes.dart';

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final daftar = model.daftarPengajuan;
    final warnaUtama = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [warnaUtama, const Color(0xFF3A82C4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Warga!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Layanan publik dalam satu aplikasi.',
                        style: TextStyle(color: Colors.white, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 29,
                  backgroundColor: Color(0x44FFFFFF),
                  child: Icon(Icons.location_city_rounded, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RingkasanCard(
                  label: 'Semua',
                  jumlah: model.jumlahPengajuan,
                  ikon: Icons.folder_open_outlined,
                  warna: const Color(0xFF145DA0),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _RingkasanCard(
                  label: 'Diproses',
                  jumlah: model.jumlahDalamProses,
                  ikon: Icons.hourglass_top_rounded,
                  warna: const Color(0xFFD18B12),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _RingkasanCard(
                  label: 'Selesai',
                  jumlah: model.jumlahSelesai,
                  ikon: Icons.check_circle_outline,
                  warna: const Color(0xFF25855A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat Pengajuan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Text('${daftar.length} pengajuan', style: const TextStyle(color: Color(0xFF687587))),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: daftar.isEmpty
                ? const _KeadaanKosong()
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: daftar.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final pengajuan = daftar[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailPengajuan,
                            arguments: pengajuan.id,
                          );
                        },
                        onLongPress: () {
                          final sudahSelesai = pengajuan.selesai;
                          context.read<PengajuanModel>().tandaiSelesai(pengajuan.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                sudahSelesai
                                    ? 'Pengajuan ini sudah selesai.'
                                    : 'Pengajuan ditandai selesai ditindaklanjuti.',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFFE4EAF1)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.description_outlined, color: warnaUtama),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pengajuan.bidang,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(pengajuan.nama, style: const TextStyle(color: Color(0xFF596779))),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${_formatTanggal(pengajuan.tanggal)} • Sesi ${pengajuan.sesi}',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF7A8797)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _StatusChip(selesai: pengajuan.selesai),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Tip: ketuk kartu untuk melihat rincian, atau tekan lama untuk menandai selesai.',
              style: TextStyle(fontSize: 11, color: Color(0xFF7A8797)),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }
}

class _RingkasanCard extends StatelessWidget {
  const _RingkasanCard({
    required this.label,
    required this.jumlah,
    required this.ikon,
    required this.warna,
  });

  final String label;
  final int jumlah;
  final IconData ikon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ikon, color: warna, size: 20),
            const SizedBox(height: 9),
            Text('$jumlah', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF697688))),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.selesai});

  final bool selesai;

  @override
  Widget build(BuildContext context) {
    final warna = selesai ? const Color(0xFF218653) : const Color(0xFFB77809);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        selesai ? 'Selesai' : 'Diproses',
        style: TextStyle(color: warna, fontWeight: FontWeight.w700, fontSize: 10),
      ),
    );
  }
}

class _KeadaanKosong extends StatelessWidget {
  const _KeadaanKosong();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Color(0xFFE7EFF8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined, size: 42, color: Color(0xFF145DA0)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Belum ada pengajuan',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tekan tombol Pengajuan Baru untuk membuat pengajuan layanan pertama.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6D7A8C), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
