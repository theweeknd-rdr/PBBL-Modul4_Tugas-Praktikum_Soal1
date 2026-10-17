import 'package:flutter/material.dart';

class TanyaPetugasPage extends StatefulWidget {
  const TanyaPetugasPage({super.key});

  @override
  State<TanyaPetugasPage> createState() => _TanyaPetugasPageState();
}

class _TanyaPetugasPageState extends State<TanyaPetugasPage> {
  final TextEditingController _pesanController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_PesanChat> _daftarPesan = [
    _PesanChat(
      teks: 'Halo! Selamat datang di layanan Tanya Petugas. Ada yang bisa kami bantu?',
      dariPetugas: true,
      waktu: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _gulirKePesanTerakhir() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _kirimPesan() async {
    final teks = _pesanController.text.trim();
    if (teks.isEmpty) return;

    setState(() {
      _daftarPesan.add(
        _PesanChat(teks: teks, dariPetugas: false, waktu: DateTime.now()),
      );
      _pesanController.clear();
    });
    _gulirKePesanTerakhir();

    // Balasan otomatis ini merupakan simulasi chat untuk tugas praktikum.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _daftarPesan.add(
        _PesanChat(
          teks: 'Terima kasih atas pesannya. Petugas akan membantu menindaklanjuti pertanyaan Anda.',
          dariPetugas: true,
          waktu: DateTime.now(),
        ),
      );
    });
    _gulirKePesanTerakhir();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.support_agent, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Petugas Layanan', style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(height: 3),
                    Text('Simulasi percakapan', style: TextStyle(fontSize: 12, color: Color(0xFF718094))),
                  ],
                ),
              ),
              const Icon(Icons.circle, color: Color(0xFF36A269), size: 10),
              const SizedBox(width: 5),
              const Text('Aktif', style: TextStyle(fontSize: 12, color: Color(0xFF36A269))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
            itemCount: _daftarPesan.length,
            itemBuilder: (context, index) {
              final pesan = _daftarPesan[index];
              return _GelembungPesan(pesan: pesan);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8EF))),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesanController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    ),
                    onSubmitted: (_) => _kirimPesan(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _kirimPesan,
                  tooltip: 'Kirim pesan',
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PesanChat {
  const _PesanChat({
    required this.teks,
    required this.dariPetugas,
    required this.waktu,
  });

  final String teks;
  final bool dariPetugas;
  final DateTime waktu;
}

class _GelembungPesan extends StatelessWidget {
  const _GelembungPesan({required this.pesan});

  final _PesanChat pesan;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final jam = '${pesan.waktu.hour.toString().padLeft(2, '0')}:'
        '${pesan.waktu.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: pesan.dariPetugas ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (pesan.dariPetugas) ...[
            const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFE2EBF6),
              child: Icon(Icons.support_agent, size: 17, color: Color(0xFF145DA0)),
            ),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: pesan.dariPetugas ? Colors.white : warna.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(17),
                    topRight: const Radius.circular(17),
                    bottomLeft: Radius.circular(pesan.dariPetugas ? 4 : 17),
                    bottomRight: Radius.circular(pesan.dariPetugas ? 17 : 4),
                  ),
                  border: pesan.dariPetugas
                      ? Border.all(color: const Color(0xFFE3E9F0))
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        pesan.teks,
                        style: TextStyle(
                          color: pesan.dariPetugas ? const Color(0xFF263547) : Colors.white,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      jam,
                      style: TextStyle(
                        fontSize: 10,
                        color: pesan.dariPetugas ? const Color(0xFF7B8796) : Colors.white70,
                      ),
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
