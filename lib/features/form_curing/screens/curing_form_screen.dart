import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/curing_provider.dart';

class CuringFormScreen extends ConsumerStatefulWidget {
  const CuringFormScreen({super.key});

  @override
  ConsumerState<CuringFormScreen> createState() => _CuringFormScreenState();
}

class _CuringFormScreenState extends ConsumerState<CuringFormScreen> {
  // Controller buat nangkep ketikan user
  final TextEditingController _tempController = TextEditingController();

  @override
  void dispose() {
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch() dipake buat nampilin status terbaru dari provider (error/sukses/loading)
    final status = ref.watch(formStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checksheet Curing'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suhu Mesin Curing (Standar: 170°C - 190°C)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan angka suhu',
                suffixText: '°C',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ref.read(formStatusProvider.notifier).submitData(_tempController.text);
                  _tempController.clear(); // Clear input setelah submit
                },
                child: const Text('Simpan Data'),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Status: $status',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: status.contains('Offline') ? Colors.orange : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Sinkronisasi Offline
            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Sinkronisasi Data Offline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                onPressed: () {
                  ref.read(formStatusProvider.notifier).syncOfflineData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
