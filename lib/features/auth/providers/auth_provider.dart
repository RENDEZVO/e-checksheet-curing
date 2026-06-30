import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthNotifier extends Notifier<UserModel?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  UserModel? build() {
    return null;
  }

  Future<String> loginKaryawan(String nip, String password) async {
    try {
      // Ubah NIP jadi email pabrik
      final emailPabrik = '$nip@pabrik.com';
      
      // Firebase Auth login check password
      await _auth.signInWithEmailAndPassword(
        email: emailPabrik,
        password: password,
      );

      // ambil data jabatannya (Role) dari tabel Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(nip).get();
      if (doc.exists) {
        final userData = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        state = userData;
        return 'SUKSES';
      } else{
        return ' Data Karyawan Tidak Ditemukan Di Database HRD';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        return 'NIP Atau Password Salah';
      } else if (e.code == 'network-request-failed') {
        return 'Tidak Ada Koneksi Internet';
      }
      return 'Eror: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan sistem: $e';
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});