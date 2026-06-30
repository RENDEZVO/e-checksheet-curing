import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../form_curing/screens/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portal EDP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('Silakan login menggunakan NIP & Password Anda.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              
              // Kolom NIP
              TextFormField(
                controller: _nipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'NIP / ID Karyawan',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 16),
              
              // Kolom Password
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure, // Biar passwordnya jadi bintang-bintang
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : () async {
                    if (_nipController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIP dan Password tidak boleh kosong!')));
                      return;
                    }

                    setState(() => _isLoading = true);
                    
                    // Panggil Firebase
                    final hasil = await ref.read(authProvider.notifier).loginKaryawan(_nipController.text, _passwordController.text);
                    
                    setState(() => _isLoading = false);

                    if (!context.mounted) return;

                    if (hasil == 'SUKSES') {
                      // Ambil data user yang berhasil login dari provider
                      final user = ref.read(authProvider);
                      
                      // Pindah ke HomeScreen dan lempar data jabatannya
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(role: user!.role, nama: user.nama),
                        ),
                      );
                    } else {
                      // Munculin pesan error spesifik dari Firebase
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hasil), backgroundColor: Colors.red));
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}