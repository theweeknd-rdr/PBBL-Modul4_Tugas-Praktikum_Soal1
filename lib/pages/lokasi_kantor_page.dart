import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiKantorPage extends StatefulWidget {
  const LokasiKantorPage({super.key});

  @override
  State<LokasiKantorPage> createState() => _LokasiKantorPageState();
}

class _LokasiKantorPageState extends State<LokasiKantorPage> {
  static const LatLng _pusatPeta = LatLng(-6.9102, 107.6096);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('balai-kota'),
      position: LatLng(-6.9102, 107.6096),
      infoWindow: InfoWindow(
        title: 'Balai Kota Bandung',
        snippet: 'Area Jl. Wastukancana, Bandung',
      ),
    ),
    const Marker(
      markerId: MarkerId('layanan-utara'),
      position: LatLng(-6.8970, 107.6130),
      infoWindow: InfoWindow(
        title: 'Kantor Layanan Wilayah Utara (simulasi)',
        snippet: 'Titik contoh untuk tugas praktikum',
      ),
    ),
    const Marker(
      markerId: MarkerId('layanan-selatan'),
      position: LatLng(-6.9235, 107.6090),
      infoWindow: InfoWindow(
        title: 'Kantor Layanan Wilayah Selatan (simulasi)',
        snippet: 'Titik contoh untuk tugas praktikum',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F0)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF145DA0)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pilih marker untuk melihat nama kantor. '
                    'Dua titik wilayah masih berupa simulasi '
                    'dan perlu diganti dengan koordinat kantor resmi.',
                    style: TextStyle(
                      color: Color(0xFF5E6B7D),
                      height: 1.35,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _pusatPeta,
                  zoom: 13.2,
                ),
                markers: _markers,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
