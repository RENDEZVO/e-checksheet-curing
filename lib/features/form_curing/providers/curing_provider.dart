import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/curing_model.dart';
import '../../auth/providers/auth_provider.dart';

class FormCuringNotifier extends Notifier<String> {
  // panggil database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  String build() {
    return 'Menunggu Input...';
  }

  Future<void> submitData(String tempInput) async {
    // Validasi 1 Harus Angka bukan huruf
    final double? temp = double.tryParse(tempInput);
    if (temp == null) {
      state = 'Error : Suhu Harus Berupa Angka!';
      return;
    }

    // Validasi Standar Suhu Mesin Curing 180°C
    if (temp < 170 || temp > 190) {
      state = 'Error : Suhu Tidak Wajar Mesin Abnormal!';
      return;
    }
    state = 'Menyimpan Data...';
    // Ambil NIP yang lagi login saat ini 
    final nipKaryawan = ref.read(authProvider) ?.nip ?? 'UNKNOWN';

    // Model biar data terstruktur
    final dataReady = CuringModel(
      temperature: temp,
      timestamp: DateTime.now(),
      operatorId: nipKaryawan,
    );

    // Simpan data ke Hive
    final box = Hive.box('curing_data');
    final int resiKey = await box.add(dataReady.toJson());
    debugPrint("Backup lokal aman! Resi: $resiKey");

    // push data ke Firestore
    try {
      await _firestore.collection('curing_reports').add({
        'temperature': dataReady.temperature,
        'timestamp': dataReady.timestamp.toIso8601String(),
        'operator_id': dataReady.operatorId,
      });
    // Auto Cleanup data yang berhasil masuk ke Firestore dari Hive biar tidak menumpuk
      await box.delete(resiKey);
      debugPrint("Sukses terkirim! data di Hive dihapus.");
      state = 'Data Berhasil Disimpan & Sinkron';
    } catch (e) {
      debugPrint("Gagal kirim ke Cloud: $e");
      state = 'Tersimpan offline (Menunggu Sinyal)';
      }
    }

    Future<void> syncOfflineData() async {
      final box = Hive.box('curing_data');
      if (box.isEmpty) {
        state = 'Semua data sudah tersinkron';
        return;
      }
      state = 'Mulai Sinkronisasi ...';
      int suksesSync = 0;

      final keys = box.keys.toList();
      for (var key in keys) {
        final data = box.get(key); 
        try {
          await _firestore.collection('curing_reports').add({
            'temperature': data['temperature'],
            'timestamp': data['timestamp'],
            'operator_id': data['operatorId'],
          });
        await box.delete(key);
        suksesSync++;
      } catch (e) {
        debugPrint('Gagal sync data resi $key: $e');
      }
    }
    state = 'Sinkronisasi Selesai! ($suksesSync data terkirim)';
    Future.delayed(const Duration(seconds: 3), () {
      state = 'Menunggu Input...';
    });
        }
      }
// 3. Daftarin ke Riverpod pakai NotifierProvider
final formStatusProvider = NotifierProvider<FormCuringNotifier, String>(() {
  return FormCuringNotifier();
});