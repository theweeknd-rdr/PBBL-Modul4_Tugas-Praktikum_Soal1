import 'package:flutter/material.dart';

import '../pages/detail_pengajuan_page.dart';
import '../pages/lokasi_kantor_page.dart';
import '../pages/rincian_layanan_page.dart';
import '../pages/statistik_layanan_page.dart';
import '../pages/tanya_petugas_page.dart';
import '../pages/warga_page.dart';
import 'app_routes.dart';

/// Kerangka navigasi terpusat. Semua tujuan utama didaftarkan dari awal di sini.
class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key, this.initialIndex = 0});

  final int initialIndex;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      case AppRoutes.warga:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const KerangkaNavigasi(initialIndex: 0),
        );
      case AppRoutes.tanyaPetugas:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const KerangkaNavigasi(initialIndex: 1),
        );
      case AppRoutes.lokasiKantor:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const KerangkaNavigasi(initialIndex: 2),
        );
      case AppRoutes.statistikLayanan:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const KerangkaNavigasi(initialIndex: 3),
        );
      case AppRoutes.rincianLayanan:
      case AppRoutes.pengajuanBaru:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RincianLayananPage(),
        );
      case AppRoutes.detailPengajuan:
        final arguments = settings.arguments;
        final id = arguments is String ? arguments : '';
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => DetailPengajuanPage(pengajuanId: id),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _RouteTidakDitemukanPage(),
        );
    }
  }

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  late int _selectedIndex;

  static const List<String> _judulHalaman = [
    'Layanan Warga',
    'Tanya Petugas',
    'Lokasi Kantor',
    'Statistik Layanan',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _judulHalaman.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    const halaman = <Widget>[
      WargaPage(),
      TanyaPetugasPage(),
      LokasiKantorPage(),
      StatistikLayananPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _judulHalaman[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: halaman),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              heroTag: 'tombol-pengajuan-baru',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.pengajuanBaru);
              },
              icon: const Icon(Icons.add),
              label: const Text('Pengajuan Baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Warga',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Lokasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}

class _RouteTidakDitemukanPage extends StatelessWidget {
  const _RouteTidakDitemukanPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
          child: const Text('Kembali ke Beranda'),
        ),
      ),
    );
  }
}
