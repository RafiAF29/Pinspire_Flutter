/// Konstanta koneksi REST API Laravel.
class ApiConstants {
  ApiConstants._();

  /// Untuk emulator Android: 10.0.2.2 (redirect ke localhost komputer).
  /// Untuk HP Android sungguhan di WiFi yang sama: ganti dengan IP komputer.
  /// Untuk Chrome/Windows/Linux/macOS: localhost.
  static const String baseUrl = 'http://10.0.2.2/pinspire-api/public/api';

  // Header standar untuk semua request JSON.
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Header dengan token autentikasi.
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
