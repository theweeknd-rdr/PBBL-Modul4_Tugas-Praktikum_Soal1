import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';

class DetailPengajuanPage extends StatelessWidget {
  const DetailPengajuanPage({super.key, required this.pengajuanId});

  final String pengajuanId;

  @override
  Widget build(BuildContext context) {
    final pengajuan = context.watch<PengajuanModel>().cariPengajuan(pengajuanId);

    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Pengajuan')),
      body: pengajuan == null
          ? const Center(child: Text('Data pengajuan tidak ditemukan.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, size: 34),
                      SizedBox(height: 12),
                      Text(
                        'Rincian pengajuan layanan',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 4),
                      Text('Informasi pengajuan yang tersimpan pada aplikasi.'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _BarisRincian(label: 'Nama lengkap', nilai: pengajuan.nama),
                        const Divider(height: 24),
                        _BarisRincian(label: 'Email', nilai: pengajuan.email),
                        const Divider(height: 24),
                        _BarisRincian(label: 'Bidang layanan', nilai: pengajuan.bidang),
                        const Divider(height: 24),
                        _BarisRincian(label: 'Sesi kunjungan', nilai: pengajuan.sesi),
                        const Divider(height: 24),
                        _BarisRincian(
                          label: 'Tanggal pengajuan',
                          nilai: _formatTanggal(pengajuan.tanggal),
                        ),
                        const Divider(height: 24),
                        _BarisRincian(
                          label: 'Status',
                          nilai: pengajuan.selesai ? 'Selesai ditindaklanjuti' : 'Dalam proses',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  static String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final jam = tanggal.hour.toString().padLeft(2, '0');
    final menit = tanggal.minute.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year} • $jam:$menit';
  }
}

class _BarisRincian extends StatelessWidget {
  const _BarisRincian({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(label, style: const TextStyle(color: Color(0xFF6A7789))),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 7,
          child: Text(
            nilai,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
