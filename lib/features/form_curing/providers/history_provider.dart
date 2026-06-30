import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/curing_model.dart';
import 'package:flutter/foundation.dart';

  final historyProvider = StreamProvider.autoDispose<List<CuringModel>>((ref) {
    final firestore = FirebaseFirestore.instance;

    return firestore
    .collection('curing_reports')
    .orderBy('timestamp', descending: true)
    .snapshots()
    .map((snapshot) {
      debugPrint('Menerima ${snapshot.docs.length} data laporan dari Firestore');

      return snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime parsedTime;
        if (data ['timestamp']is Timestamp) {
          parsedTime = (data['timestamp'] as Timestamp).toDate();
        } else if (data['timestamp'] is String) {
          parsedTime = DateTime.parse(data['timestamp']);
        } else {
          parsedTime = DateTime.now();
        }


        return CuringModel(
          temperature: (data['temperature'] as num?)?.toDouble() ?? 0.0,
          timestamp : parsedTime,
          operatorId: data['operator_id']?.toString() ?? 'UNKNOWN',
        );
      }).toList();
    });
  });