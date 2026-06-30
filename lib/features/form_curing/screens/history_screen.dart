import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch ke StreamProvider bakal mengembalikan tipe AsyncValue
    final historyState = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('History Laporan Mesin', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent, // Warna merah identik dengan Admin
        foregroundColor: Colors.white,
      ),
      // Handling state Data, Loading, dan Error secara bersih di UI
      body: historyState.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Text('Belum ada data laporan masuk.', style: TextStyle(fontSize: 16)),
            );
          }

          // Pake ListView.builder biar render UI cuma buat yang keliatan di layar aja
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final jam = DateFormat('HH:mm').format(report.timestamp);
              final tanggal = DateFormat('dd MMM yyyy').format(report.timestamp);
              
              // Logika visual ringan di UI: Tentukan warna berdasarkan suhu
              final isAbnormal = report.temperature < 170 || report.temperature > 190;
              final statusColor = isAbnormal ? Colors.red : Colors.green;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: statusColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withOpacity(0.2),
                    child: Icon(
                      isAbnormal ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      color: statusColor,
                    ),
                  ),
                  title: Text(
                    'Suhu: ${report.temperature}°C',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Operator: NIP ${report.operatorId}\n$tanggal | Jam $jam',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Gagal memuat data:\n$error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}