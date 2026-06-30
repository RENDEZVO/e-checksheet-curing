class CuringModel {
  final double temperature;
  final DateTime timestamp;
  final String operatorId;

  CuringModel({
    required this.temperature,
    required this.timestamp,
    required this.operatorId,
  });

  // Fungsi buat ngubah data objek jadi format JSON (buat nembak API)
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'timestamp': timestamp.toIso8601String(),
      'operator_id': operatorId,
    };
  }
}