import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; 
import 'curing_form_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role; 
  final String nama;

  const HomeScreen({super.key, required this.role, required this.nama});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _waktuSekarang = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Bikin jamnya berdetak tiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _waktuSekarang = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format tanggal: Senin, 28 Juni 2026
    String tanggal = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_waktuSekarang);
    // Format jam: 14:30:05
    String jam = DateFormat('HH:mm:ss').format(_waktuSekarang);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Utama'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER REALTIME ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tanggal, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(jam, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Nampilin Badge Role
                Chip(
                  label: Text(widget.role.toUpperCase(), style: const TextStyle(color: Colors.white)),
                  backgroundColor: widget.role == 'admin' ? Colors.redAccent : Colors.green,
                )
              ],
            ),
            const Divider(height: 32, thickness: 2),
            
            Text('Selamat Datang, ${widget.nama}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),

            // --- TOMBOL MENU ---
            // Tombol ini muncul buat SEMUA role
            _buildMenuCard(
              context, 
              title: 'Input Laporan Mesin Curing',
              icon: Icons.assignment_add,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CuringFormScreen()));
              },
            ),
            const SizedBox(height: 16),

            // Tombol ini CUMA MUNCUL kalau dia ADMIN
            if (widget.role == 'admin')
              _buildMenuCard(
                context, 
                title: 'History Laporan (Admin Only)',
                icon: Icons.history,
                color: Colors.redAccent,
                onTap: () {
                  // Nanti arahin ke halaman History
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Widget buat bikin tombol menu kotak yang rapi
  Widget _buildMenuCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}