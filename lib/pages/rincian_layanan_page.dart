import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';

class RincianLayananPage extends StatefulWidget {
  const RincianLayananPage({super.key});

  @override
  State<RincianLayananPage> createState() => _RincianLayananPageState();
}

class _RincianLayananPageState extends State<RincianLayananPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _setujuDataPribadi = false;
  bool _sedangMengirim = false;
  String? _bidangTerpilih;
  String? _sesiTerpilih;

  bool get _emailValid => _emailController.text.trim().contains('@');

  bool get _formLengkap {
    return _namaController.text.trim().isNotEmpty &&
        _emailValid &&
        _bidangTerpilih != null &&
        _sesiTerpilih != null &&
        _setujuDataPribadi &&
        !_sedangMengirim;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _kirimPengajuan() async {
    if (!_formLengkap) return;

    setState(() => _sedangMengirim = true);
    // Simulasi proses pengiriman sebelum data masuk ke state bersama.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    context.read<PengajuanModel>().tambahPengajuan(
          nama: _namaController.text,
          email: _emailController.text,
          bidang: _bidangTerpilih!,
          sesi: _sesiTerpilih!,
        );

    setState(() => _sedangMengirim = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengajuan berhasil disimpan.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final warnaUtama = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Pengajuan Layanan')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.assignment_outlined, size: 34),
                        SizedBox(height: 10),
                        Text(
                          'Ajukan layanan dengan mudah',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Lengkapi data di bawah ini. Pengajuan akan tersimpan '
                          'di riwayat aplikasi setelah dikirim.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Data pemohon',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _namaController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama lengkap',
                      hintText: 'Masukkan nama sesuai identitas',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'nama@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: _emailController.text.trim().isNotEmpty &&
                              !_emailValid
                          ? 'Email harus mengandung karakter @'
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _bidangTerpilih,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Bidang layanan',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: PengajuanModel.bidangLayanan
                        .map(
                          (bidang) => DropdownMenuItem<String>(
                            value: bidang,
                            child: Text(bidang),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _bidangTerpilih = value);
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Pilih sesi kunjungan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  RadioGroup<String>(
                    groupValue: _sesiTerpilih,
                    onChanged: (value) {
                      setState(() => _sesiTerpilih = value);
                    },
                    child: Column(
                      children: ['Pagi', 'Siang', 'Sore']
                          .map(
                            (sesi) => RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(sesi),
                              value: sesi,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.white,
                    child: CheckboxListTile(
                      value: _setujuDataPribadi,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                      title: const Text(
                        'Saya menyetujui penggunaan data pribadi untuk proses layanan.',
                      ),
                      onChanged: (value) {
                        setState(() => _setujuDataPribadi = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _formLengkap ? _kirimPengajuan : null,
                      icon: _sedangMengirim
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _sedangMengirim ? 'Sedang mengirim...' : 'Kirim Pengajuan',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warnaUtama,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFDCE3EC),
                        disabledForegroundColor: const Color(0xFF768397),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Tombol aktif setelah semua data lengkap dan persetujuan dicentang.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7788)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
