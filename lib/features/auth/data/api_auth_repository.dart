import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_constants.dart';
import '../models/data_registrasi.dart';
import 'auth_repository.dart';

/// Implementasi [AuthRepository] yang memanggil REST API Laravel.
///
/// Untuk beralih dari mock ke API sungguhan, cukup ganti objek
/// [authRepository] di auth_repository.dart:
///   final AuthRepository authRepository = ApiAuthRepository();
class ApiAuthRepository implements AuthRepository {
  AkunPengguna? _akun;

  @override
  AkunPengguna? get akunSaatIni => _akun;

  // ----------- Utilitas token -----------

  Future<String?> _ambilToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _simpanToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _hapusToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ----------- Endpoint auth -----------

  @override
  Future<bool> emailTerdaftar(String email) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/check-email'),
      headers: ApiConstants.jsonHeaders,
      body: jsonEncode({'email': email.trim().toLowerCase()}),
    );
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['terdaftar'] == true;
  }

  @override
  Future<AkunPengguna> masuk({
    required String email,
    required String kataSandi,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      headers: ApiConstants.jsonHeaders,
      body: jsonEncode({
        'email': email.trim().toLowerCase(),
        'password': kataSandi,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      throw AuthException(
        data['message'] as String? ?? 'Login gagal.',
      );
    }
    await _simpanToken(data['token'] as String);
    final user = data['user'] as Map<String, dynamic>;
    return _akun = AkunPengguna(
      email: user['email'] as String,
      nama: user['name'] as String,
      minat: _parsMinat(data['minat']),
    );
  }

  @override
  Future<AkunPengguna> daftar(DataRegistrasi data) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/register'),
      headers: ApiConstants.jsonHeaders,
      body: jsonEncode({
        'name': data.nama,
        'email': data.email.trim().toLowerCase(),
        'password': data.kataSandi,
        'jenis_kelamin': data.jenisKelamin?.name,
        'tanggal_lahir': data.tanggalLahir?.toIso8601String(),
        'negara': data.negara,
        'minat': data.minat.toList(),
      }),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw AuthException(
        body['message'] as String? ?? 'Registrasi gagal.',
      );
    }
    await _simpanToken(body['token'] as String);
    final user = body['user'] as Map<String, dynamic>;
    return _akun = AkunPengguna(
      email: user['email'] as String,
      nama: user['name'] as String,
      minat: Set<String>.from(data.minat),
    );
  }

  @override
  Future<AkunPengguna> masukDenganGoogle(AkunGoogle akun) async {
    // Untuk demo UTS: login/register via email biasa.
    // Google OAuth sungguhan membutuhkan konfigurasi tambahan.
    final terdaftar = await emailTerdaftar(akun.email);
    if (terdaftar) {
      return _akun = AkunPengguna(email: akun.email, nama: akun.nama);
    }
    return _akun = AkunPengguna(email: akun.email, nama: akun.nama);
  }

  @override
  Future<void> keluar() async {
    final token = await _ambilToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
          headers: ApiConstants.authHeaders(token),
        );
      } catch (_) {
        // Abaikan error jaringan saat logout.
      }
    }
    await _hapusToken();
    _akun = null;
  }

  // ----------- Utilitas -----------

  Set<String> _parsMinat(dynamic raw) {
    if (raw == null) return const {};
    if (raw is List) return Set<String>.from(raw.map((e) => e.toString()));
    return const {};
  }
}
