import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';

class StatistikLayananPage extends StatelessWidget {
  const StatistikLayananPage({super.key});

  static const List<String> _labelPendek = [
    'Admin.\nKependudukan',
    'Perizinan',
    'Kesehatan',
    'Pendidikan',
  ];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final statistik = model.statistikPerBidang;
    final nilai = PengajuanModel.bidangLayanan
        .map((bidang) => statistik[bidang] ?? 0)
        .toList();
    final maksimum = nilai.fold<int>(
      0,
      (terbesar, angka) => angka > terbesar ? angka : terbesar,
    );
    final maxY = (maksimum + 2).toDouble();
    final warnaUtama = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan pengajuan warga',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          const Text(
            'Grafik diperbarui otomatis dari data PengajuanModel.',
            style: TextStyle(color: Color(0xFF718094), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _KartuStatistik(
                  judul: 'Total pengajuan',
                  angka: model.jumlahPengajuan,
                  ikon: Icons.folder_copy_outlined,
                  warna: warnaUtama,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _KartuStatistik(
                  judul: 'Selesai',
                  angka: model.jumlahSelesai,
                  ikon: Icons.task_alt_rounded,
                  warna: const Color(0xFF25855A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE3E9F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 18, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        'Jumlah per bidang layanan',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: maxY,
                          alignment: BarChartAlignment.spaceAround,
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 != 0) return const SizedBox.shrink();
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 8,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF6D7A8B)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 52,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= _labelPendek.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 8,
                                    child: SizedBox(
                                      width: 72,
                                      child: Text(
                                        _labelPendek[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF6D7A8B),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List<BarChartGroupData>.generate(
                            PengajuanModel.bidangLayanan.length,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: nilai[index].toDouble(),
                                  width: 28,
                                  color: warnaUtama,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Jumlah dihitung dari pengajuan yang dibuat selama sesi aplikasi ini berjalan.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF7A8797)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuStatistik extends StatelessWidget {
  const _KartuStatistik({
    required this.judul,
    required this.angka,
    required this.ikon,
    required this.warna,
  });

  final String judul;
  final int angka;
  final IconData ikon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: warna.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ikon, color: warna, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$angka', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  Text(judul, style: const TextStyle(fontSize: 11, color: Color(0xFF6D7A8B))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
