# PROJECT OVERVIEW
Aplikasi E-Checksheet pelaporan suhu Mesin Curing untuk internal pabrik manufaktur. Fokus utama pada kapabilitas Offline-First (tahan area blank spot) dan Role-Based Access Control (RBAC) untuk pemisahan wewenang Operator dan Admin. Aplikasi ini dirancang dengan standar industri untuk memastikan keandalan tinggi dan performa yang optimal di lapangan.

# TECH STACK & VERSI
- Frontend: Flutter (Dart)
- State Management: Riverpod (v3+) -> Menggunakan Notifier & NotifierProvider modern.
- Local Database (Offline): Hive (NoSQL Key-Value Store)
- Cloud Backend/Database: Firebase (Firebase Auth & Cloud Firestore)

# PRINSIP CLEAN ARCHITECTURE (WAJIB DIIKUTI)
1. DILARANG keras menggunakan `StateNotifier` atau `ChangeNotifier`. Semua state manajemen wajib menggunakan arsitektur modern `Notifier`.
2. Pemisahan Layer Mutlak: 
   - UI Layer (screens/widgets) hanya bertugas untuk menampilkan visual dan menerima input fisik.
   - Business Logic Layer (providers) bertugas mengolah data, validasi, dan komunikasi ke database.
3. DILARANG mencampur logika bisnis atau fungsi asinkron (`Future`/`Stream`) langsung di dalam file UI. UI hanya boleh memicu fungsi melalui `ref.read()`.
4. Dependensi Satu Arah: File UI boleh membaca file Provider, tetapi file Provider DILARANG keras tahu-menahu tentang struktur widget UI.

# MANAJEMEN CACHE & PERFORMA INDUSTRI (ANTI-LEMOT)
1. Pencegahan Memory Leak: Setiap penggunaan `TextEditingController`, `ScrollController`, atau `StreamSubscription` di layer UI WAJIB dihancurkan menggunakan fungsi `dispose()` ketika layar ditutup.
2. Efisiensi Database Lokal: Kotak Hive (`Hive.box`) yang digunakan untuk caching offline tidak boleh dibuka-tutup berulang kali di dalam loop. Buka sekali di awal (`main.dart`) dan gunakan referensi box yang sudah aktif.
3. Optimasi Render UI: Gunakan `ref.watch()` hanya pada variabel spesifik yang perlu berubah di layar. Hindari me-rebuild seluruh halaman secara besar-besaran jika hanya satu komponen teks yang berubah.
4. Clean Log Environment: DILARANG menggunakan fungsi `print()` bawaan di fase produksi karena memakan resource CPU. Gunakan `debugPrint()` atau package `logger` khusus industri.
5. Auto-Cleanup Cache: Data lama di dalam Hive yang sudah sukses disinkronisasi ke Cloud Firestore harus dibersihkan secara berkala agar penyimpanan internal HP tidak membengkak.

# DIRECTORY STRUCTURE
- `/lib/features/auth/models` : Model data terkait pengguna (contoh: UserModel).
- `/lib/features/auth/providers` : Logika bisnis autentikasi (Login, Cek Sesi).
- `/lib/features/auth/screens` : UI Layar Login.
- `/lib/features/form_curing/models` : Cetakan data pelaporan mesin (contoh: CuringModel).
- `/lib/features/form_curing/providers` : Logika validasi suhu mesin, simpan data ke Hive, dan integrasi Firestore.
- `/lib/features/form_curing/screens` : UI Dashboard Utama (Jam Realtime) dan Form E-Checksheet.

# DATABASE SCHEMA
Table (Firestore Collection): `users` (Data Karyawan)
- `Document ID` (text/NIP, primary key)
- `nip` (text, not null)
- `nama` (text, not null)
- `role` (text, "admin" atau "operator")

Table (Firestore Collection): `curing_reports` (Data Pelaporan Mesin)
- `Document ID` (auto-generated)
- `temperature` (number/double, not null)
- `timestamp` (timestamp/datetime, not null)
- `operatorId` (text/NIP, not null)

Local Box (Hive): `curing_data`
- Menyimpan List of JSON dari model `CuringModel` sebagai backup offline sementara.

# STATUS PROJECT: MVP SELESAI (V 1.0.0)
Semua fitur inti telah berhasil diimplementasikan sesuai standar:
- [x] Sistem Login RBAC terintegrasi dengan Firebase Auth.
- [x] Dashboard UI dengan jam realtime dan pembatasan akses menu.
- [x] Form input data dengan validasi batas suhu operasional.
- [x] Arsitektur Offline-First: Penyimpanan otomatis ke Hive jika koneksi terputus.
- [x] Sinkronisasi Manual & Auto-Cleanup: Pengiriman ulang data tertunda ke Firestore dan pembersihan memori lokal (Cache).
- [x] Realtime Dashboard History Laporan khusus wewenang Admin.