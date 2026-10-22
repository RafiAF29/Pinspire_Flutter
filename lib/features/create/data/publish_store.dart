import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/api_constants.dart';
import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import 'board_store.dart';

enum PublishFase { diam, mengunggah, terbit }

/// Status unggah pin — upload ke API (POST /api/pins, multipart).
class PublishStore extends ChangeNotifier {
  PublishStore._();
  static final PublishStore instance = PublishStore._();

  static const durasiToast = Duration(milliseconds: 4500);

  PublishFase _fase = PublishFase.diam;
  double _progres = 0;
  Pin? _pin;
  Timer? _timer;

  PublishFase get fase => _fase;
  double get progres => _progres;
  Pin? get pin => _pin;

  /// Mulai unggah pin ke API.
  void mulai(
    Pin pin, {
    Board? papan,
    String? deskripsi,
    String? tautan,
  }) {
    _timer?.cancel();
    _pin = pin;
    _fase = PublishFase.mengunggah;
    _progres = 0;
    notifyListeners();

    _uploadKeApi(pin, papan: papan, deskripsi: deskripsi, tautan: tautan);
  }

  Future<void> _uploadKeApi(
    Pin pin, {
    Board? papan,
    String? deskripsi,
    String? tautan,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        _selesaiLokal(pin, papan);
        return;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}/pins');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // ── Fields ──
      if (pin.title != null && pin.title!.isNotEmpty) {
        request.fields['title'] = pin.title!;
      }
      if (deskripsi != null && deskripsi.isNotEmpty) {
        request.fields['description'] = deskripsi;
      }
      if (tautan != null && tautan.isNotEmpty) {
        request.fields['link_url'] = tautan;
      }
      request.fields['aspect'] = pin.aspect.toStringAsFixed(2);
      if (papan != null && !papan.id.startsWith('temp_')) {
        request.fields['board_id'] = papan.id;
      }

      // ── Gambar ──
      Uint8List? imageBytes;

      if (pin.bytes != null) {
        // Foto dari kamera.
        imageBytes = pin.bytes;
      } else if (pin.image.startsWith('assets/')) {
        // Asset bundled (galeri dummy).
        try {
          final byteData = await rootBundle.load(pin.image);
          imageBytes = byteData.buffer.asUint8List();
        } catch (_) {}
      }

      if (imageBytes != null && imageBytes.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'pin_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      } else {
        // Tidak ada gambar untuk diupload — gagal.
        debugPrint('Tidak ada gambar untuk diupload');
        _selesaiLokal(pin, papan);
        return;
      }

      _progres = 0.3;
      notifyListeners();

      final streamedRes = await request.send();

      _progres = 0.8;
      notifyListeners();

      final resBody = await streamedRes.stream.bytesToString();

      if (streamedRes.statusCode == 201 || streamedRes.statusCode == 200) {
        _progres = 1;
        _fase = PublishFase.terbit;

        try {
          final data = jsonDecode(resBody) as Map<String, dynamic>;
          final serverPin = Pin.fromJson(data);
          SavedStore.instance.tambahBuatan(serverPin);
          if (papan != null) BoardStore.instance.tambahPin(papan, serverPin);
          _pin = serverPin;
        } catch (_) {
          SavedStore.instance.tambahBuatan(pin);
          if (papan != null) BoardStore.instance.tambahPin(papan, pin);
        }
        notifyListeners();

        _timer = Timer(durasiToast, () {
          _fase = PublishFase.diam;
          _pin = null;
          notifyListeners();
        });
      } else {
        debugPrint('Upload pin gagal: ${streamedRes.statusCode} $resBody');
        _selesaiLokal(pin, papan);
      }
    } catch (e) {
      debugPrint('Upload pin error: $e');
      _selesaiLokal(pin, papan);
    }
  }

  void _selesaiLokal(Pin pin, Board? papan) {
    _progres = 1;
    _fase = PublishFase.terbit;
    SavedStore.instance.tambahBuatan(pin);
    if (papan != null) BoardStore.instance.tambahPin(papan, pin);
    notifyListeners();

    _timer = Timer(durasiToast, () {
      _fase = PublishFase.diam;
      _pin = null;
      notifyListeners();
    });
  }

  /// Tombol X di bar unggah.
  void batal() {
    _timer?.cancel();
    _fase = PublishFase.diam;
    _pin = null;
    notifyListeners();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
