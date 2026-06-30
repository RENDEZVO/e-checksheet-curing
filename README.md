# 🏭 E-Checksheet Mesin Curing

Aplikasi E-Checksheet berbasis mobile dan web untuk pelaporan suhu Mesin Curing di lingkungan pabrik manufaktur. Aplikasi ini dirancang menggunakan arsitektur **Offline-First**, memungkinkan pekerja lapangan tetap dapat melakukan pelaporan meskipun berada di area *blank spot* (tanpa koneksi internet).

## 🚀 Fitur Utama
* **Offline-First Architecture:** Data disimpan secara lokal (Cache) dan akan disinkronisasikan ke Cloud (Firebase) ketika koneksi internet kembali tersedia. Termasuk fitur *Auto-Cleanup* untuk menjaga performa memori perangkat.
* **Role-Based Access Control (RBAC):** Pemisahan otorisasi halaman secara ketat berdasarkan wewenang pengguna (Admin vs Operator).
* **Realtime Dashboard:** Menampilkan waktu aktual (berdetak) sesuai standar shift pabrik.
* **Validasi Standar Manufaktur:** Peringatan otomatis jika suhu mesin yang diinput berada di luar standar operasional (170°C - 190°C).

## 🛠️ Tech Stack
* **Framework:** Flutter (Dart)
* **State Management:** Riverpod v3 (Notifier & NotifierProvider)
* **Local Storage:** Hive (NoSQL Key-Value Store)
* **Cloud Backend:** Firebase Auth & Cloud Firestore

## 👥 Sistem Role & Flow Aplikasi

Aplikasi ini memiliki 2 tingkatan wewenang pengguna:

### 1. 👨‍🔧 Operator (Pekerja Lapangan)
* **Flow:** Login (NIP & Password) ➔ Dashboard ➔ Form Input Suhu.
* **Akses:** Hanya dapat mengisi data laporan mesin.
* **Fitur Tambahan:** Memiliki tombol *Sinkronisasi Manual* untuk mengirim data yang tertunda/nyangkut di lokal (Hive) akibat kehilangan sinyal internet.

### 2. 👨‍💼 Admin Operator (Supervisor)
* **Flow:** Login (NIP & Password) ➔ Dashboard ➔ History Laporan.
* **Akses:** Memiliki seluruh wewenang Operator, **ditambah** akses eksklusif ke halaman riwayat pelaporan.
* **Fitur Tambahan:** Memantau seluruh *log* suhu mesin secara *realtime* lengkap dengan NIP penanggung jawab (Operator) untuk mempermudah pelacakan jika terjadi anomali produksi.

## 💻 Cara Menjalankan Aplikasi (Getting Started)

Pastikan Anda sudah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) pada perangkat Anda.

1. **Clone repository ini:**
   ```bash
   git clone [https://github.com/RENDEZVO/e-checksheet-curing.git](https://github.com/RENDEZVO/e-checksheet-curing.git)

   Masuk ke dalam direktori project:
   "cd e-checksheet-curing"

   Install semua package/dependencies:
   "flutter pub get"

   Jalankan aplikasi:
   "flutter run"

   Untuk menjalankannya secara ringan di Browser (Web Mode):
   "flutter run -d chrome"
