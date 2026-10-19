import 'package:flutter/foundation.dart' show kIsWeb;

/// Konstanta koneksi REST API Laravel.
class ApiConstants {
  ApiConstants._();

  /// Base URL otomatis berdasarkan platform:
  /// - Chrome / Windows / macOS / Linux → 127.0.0.1 (localhost)
  /// - Emulator Android                → 10.0.2.2 (redirect ke localhost komputer)
  /// - HP Android sungguhan via WiFi   → ganti ke IP komputer, misal 192.168.x.x
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8001/api';
    return 'http://10.0.2.2:8001/api';
  }

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
