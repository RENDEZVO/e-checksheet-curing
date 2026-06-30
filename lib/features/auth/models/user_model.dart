class UserModel {
  final String nip;
  final String nama;
  final String role;

  UserModel({
    required this.nip,
    required this.nama,
    required this.role,
  });

  // Buat ngubah data dari Firebase ke Flutter
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nip: json['nip'] ?? '',
      nama: json['nama'] ?? '',
      role: json['role'] ?? 'operator', // Defaultnya operator kalau kosong
    );
  }
}