import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../data/galeri_data.dart';
import '../data/gallery_access_store.dart';
import '../../search/pages/pencarian_foto_page.dart';
import 'editor_pin_page.dart';

enum _Status { memuat, siap, ditolak, galat }

/// Kamera sungguhan (paket `camera`): pratinjau langsung, foto, dan video
/// hingga 5 menit. Jalan di HP Android/iOS, Windows, dan Web (Chrome).
///
/// Izin kamera & mikrofon diminta oleh sistem (HP / browser) saat kamera
/// dibuka pertama kali; setelah diizinkan tidak ditanya lagi.
class KameraPage extends StatefulWidget {
  const KameraPage({super.key, this.untukCari = false});

  /// true = dibuka dari ikon kamera di kolom pencarian: hanya foto, lalu
  /// hasilnya dipakai untuk pencarian (bukan membuat Pin).
  final bool untukCari;

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  static const _latarGelap = Color(0xFF2B2B27);
  static const _maksDetik = 300; // 5 menit
  static const _pilihanTimer = [0, 3, 10];

  _Status _status = _Status.memuat;
  String _pesan = '';

  List<CameraDescription> _daftar = [];
  int _idx = 0;
  CameraController? _c;

  late bool _video = !widget.untukCari;
  bool _flash = false;
  int _timerIdx = 0;

  int? _hitungMundur;
  bool _merekam = false;
  bool _sibuk = false; // sedang memotret / memproses
  int _detik = 0;
  Timer? _ticker;
  XFile? _sampulVideo;

  @override
  void initState() {
    super.initState();
    _mulai();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _c?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- kamera

  Future<void> _mulai() async {
    setState(() => _status = _Status.memuat);
    try {
      if (_daftar.isEmpty) {
        _daftar = await availableCameras();
        // Utamakan kamera belakang; di laptop biasanya hanya ada satu.
        final b = _daftar.indexWhere(
          (d) => d.lensDirection == CameraLensDirection.back,
        );
        _idx = b < 0 ? 0 : b;
      }
      if (_daftar.isEmpty) {
        _gagal(_Status.galat, AppStrings.camNone);
        return;
      }
      await _pasang(_idx);
    } on CameraException catch (e) {
      final ditolak = e.code.contains('AccessDenied');
      _gagal(
        ditolak ? _Status.ditolak : _Status.galat,
        ditolak
            ? AppStrings.camDenied
            : '${AppStrings.camError}\n(${e.code}: ${e.description ?? '-'})',
      );
    } catch (e) {
      _gagal(_Status.galat, '${AppStrings.camError}\n($e)');
    }
  }

  void _gagal(_Status s, String pesan) {
    if (!mounted) return;
    setState(() {
      _status = s;
      _pesan = pesan;
    });
  }

  Future<void> _pasang(int idx) async {
    final lama = _c;
    if (lama != null) {
      setState(() => _c = null);
      await lama.dispose();
    }

    final baru = await _buka(_daftar[idx]);
    if (!mounted) {
      await baru.dispose();
      return;
    }

    // Sampai sini izin sudah diberikan -> catat per akun.
    GalleryAccessStore.instance
      ..izinkanKamera()
      ..izinkanAudio();

    await _terapkanFlash(baru);
    setState(() {
      _c = baru;
      _idx = idx;
      _status = _Status.siap;
    });
  }

  /// Coba beberapa konfigurasi: resolusi tinggi + audio, lalu resolusi
  /// sedang + audio, lalu tanpa audio (mis. laptop/PC tanpa mikrofon).
  Future<CameraController> _buka(CameraDescription desk) async {
    const percobaan = [
      (ResolutionPreset.high, true),
      (ResolutionPreset.medium, true),
      (ResolutionPreset.medium, false),
    ];
    Object? galat;
    for (final (preset, audio) in percobaan) {
      final c = CameraController(desk, preset, enableAudio: audio);
      try {
        await c.initialize();
        return c;
      } on CameraException catch (e) {
        galat = e;
        await _buang(c);
        // Kamera diblokir pengguna: percuma dicoba lagi.
        if (e.code.startsWith('CameraAccessDenied')) rethrow;
      } catch (e) {
        galat = e;
        await _buang(c);
      }
    }
    throw galat ?? StateError('Kamera tidak dapat dibuka');
  }

  Future<void> _buang(CameraController c) async {
    try {
      await c.dispose();
    } catch (_) {}
  }

  Future<void> _terapkanFlash(CameraController c) async {
    try {
      await c.setFlashMode(
        !_flash
            ? FlashMode.off
            : (_video ? FlashMode.torch : FlashMode.always),
      );
    } catch (_) {
      // Webcam laptop umumnya tidak punya lampu kilat.
    }
  }

  Future<void> _balik() async {
    if (_daftar.length < 2 || _merekam || _sibuk) return;
    try {
      await _pasang((_idx + 1) % _daftar.length);
    } catch (_) {
      _gagal(_Status.galat, AppStrings.camError);
    }
  }

  // --------------------------------------------------------------- aksi

  String _format(int detik) =>
      '${detik ~/ 60}:${(detik % 60).toString().padLeft(2, '0')}';

  void _gantiMode(bool video) {
    if (_merekam || _hitungMundur != null) return;
    setState(() => _video = video);
    final c = _c;
    if (c != null) _terapkanFlash(c);
  }

  void _tekanShutter() {
    final c = _c;
    if (c == null || !c.value.isInitialized || _sibuk) return;

    if (_merekam) {
      _berhenti();
      return;
    }
    if (_hitungMundur != null) return;

    final tunda = _pilihanTimer[_timerIdx];
    if (tunda == 0) {
      _eksekusi();
      return;
    }
    setState(() => _hitungMundur = tunda);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      final sisa = (_hitungMundur ?? 1) - 1;
      if (sisa <= 0) {
        t.cancel();
        setState(() => _hitungMundur = null);
        _eksekusi();
      } else {
        setState(() => _hitungMundur = sisa);
      }
    });
  }

  Future<void> _eksekusi() async {
    final c = _c;
    if (c == null) return;
    try {
      if (!_video) {
        setState(() => _sibuk = true);
        final foto = await c.takePicture();
        await _selesai(foto, null, null);
        return;
      }

      // Video: ambil satu foto dulu sebagai gambar sampul pin.
      try {
        _sampulVideo = await c.takePicture();
      } catch (_) {
        _sampulVideo = null;
      }
      await c.startVideoRecording();
      if (!mounted) return;
      setState(() {
        _merekam = true;
        _detik = 0;
      });
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() => _detik++);
        if (_detik >= _maksDetik) _berhenti();
      });
    } catch (_) {
      _gagal(_Status.galat, AppStrings.camError);
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  Future<void> _berhenti() async {
    final c = _c;
    if (c == null || !_merekam || _sibuk) return;
    _ticker?.cancel();
    final lama = _detik < 1 ? 1 : _detik;
    setState(() {
      _merekam = false;
      _sibuk = true;
    });
    try {
      final video = await c.stopVideoRecording();
      await _selesai(_sampulVideo, _format(lama), video.path);
    } catch (_) {
      _gagal(_Status.galat, AppStrings.camError);
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  Future<void> _selesai(XFile? gambar, String? durasi, String? video) async {
    var aspek = 0.75;
    final bytes = gambar == null ? null : await gambar.readAsBytes();
    if (bytes != null) {
      final img = await decodeImageFromList(bytes);
      if (img.height > 0) aspek = img.width / img.height;
    }
    if (!mounted) return;

    if (widget.untukCari) {
      if (bytes == null) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => PencarianFotoPage(foto: bytes, aspek: aspek),
        ),
      );
      return;
    }

    final item = GaleriItem(
      'kamera_${DateTime.now().microsecondsSinceEpoch}',
      'Hari Ini',
      aspect: aspek,
      durasi: durasi,
      bytes: bytes,
      videoPath: video,
    );
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EditorPinPage(item: item)),
    );
  }

  // --------------------------------------------------------------- tampilan

  @override
  Widget build(BuildContext context) {
    if (_status != _Status.siap) return _layarIzin();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _atas(),
            Expanded(child: _pratinjau()),
            const SizedBox(height: 14),
            if (widget.untukCari)
              const SizedBox(height: 32)
            else if (!_merekam)
              _pilihMode()
            else
              const SizedBox(height: 32),
            const SizedBox(height: 14),
            _shutter(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Layar gelap "Gunakan kamera Anda" (tampil saat memuat / izin ditolak).
  Widget _layarIzin() {
    final store = GalleryAccessStore.instance;
    Widget baris(String label, bool ok) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                ok ? Icons.check_circle_outline : Icons.circle_outlined,
                size: 18,
                color: ok ? const Color(0xFFE9E9E4) : const Color(0xFF77776F),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: ok ? const Color(0xFFE9E9E4) : const Color(0xFF77776F),
                ),
              ),
            ],
          ),
        );

    return Scaffold(
      backgroundColor: _latarGelap,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.keyboard_arrow_down,
                        size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.help_outline, size: 26, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        AppStrings.permCamTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE9E9E4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.permCamBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Color(0xFFE0E0DA),
                        ),
                      ),
                      const SizedBox(height: 20),
                      baris(AppStrings.permCamera, store.izinKamera),
                      baris(AppStrings.permAudio, store.izinAudio),
                      baris(AppStrings.permGallery, true),
                      const SizedBox(height: 16),
                      if (_status == _Status.memuat)
                        const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white70,
                          ),
                        )
                      else ...[
                        Text(
                          _pesan,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.3,
                            color: Color(0xFFE0E0DA),
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: _mulai,
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _status == _Status.ditolak
                                  ? AppStrings.permButton
                                  : AppStrings.camRetry,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _atas() {
    final String judul;
    if (_merekam) {
      judul = _format(_detik);
    } else if (widget.untukCari) {
      judul = AppStrings.camSearchTitle;
    } else {
      judul = _video ? AppStrings.camRecordUpTo : AppStrings.camPortrait;
    }
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.keyboard_arrow_down,
                        size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 18),
                  const Icon(Icons.help_outline, size: 26, color: Colors.white),
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_merekam) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Pratinjau langsung, dipotong memenuhi kotak (BoxFit.cover).
  Widget _viewfinder(CameraController c) {
    final rasio = c.value.aspectRatio;
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: rasio * 1000,
          height: 1000,
          child: CameraPreview(c),
        ),
      ),
    );
  }

  Widget _pratinjau() {
    final c = _c;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF1C1C1A)),
          if (c != null && c.value.isInitialized) _viewfinder(c),
          if (_hitungMundur != null)
            Center(
              child: Text(
                '$_hitungMundur',
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          if (!_merekam)
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _kontrol(
                      Icons.timer_outlined,
                      _pilihanTimer[_timerIdx] == 0
                          ? AppStrings.camTimer
                          : '${_pilihanTimer[_timerIdx]} d',
                      () => setState(() =>
                          _timerIdx = (_timerIdx + 1) % _pilihanTimer.length),
                      key: const ValueKey('kamera-timer'),
                    ),
                    const SizedBox(height: 14),
                    _kontrol(
                      _flash ? Icons.flash_on : Icons.flash_off,
                      AppStrings.camFlash,
                      () {
                        setState(() => _flash = !_flash);
                        if (c != null) _terapkanFlash(c);
                      },
                      key: const ValueKey('kamera-flash'),
                    ),
                    const SizedBox(height: 14),
                    _kontrol(
                      Icons.flip_camera_android_outlined,
                      AppStrings.camFlip,
                      _balik,
                      key: const ValueKey('kamera-balik'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _kontrol(IconData ikon, String label, VoidCallback onTap, {Key? key}) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 24, color: Colors.white),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pilihMode() {
    Widget item(String label, bool video) {
      final aktif = _video == video;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _gantiMode(video),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aktif ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: aktif ? Colors.black : Colors.white,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item(AppStrings.tabVideo, true),
        item(AppStrings.tabPhoto, false),
      ],
    );
  }

  Widget _shutter() {
    return GestureDetector(
      key: const ValueKey('kamera-shutter'),
      behavior: HitTestBehavior.opaque,
      onTap: _tekanShutter,
      child: Container(
        width: 76,
        height: 76,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.all(_merekam ? 14 : 0),
          decoration: BoxDecoration(
            color: _video ? const Color(0xFFFF4B4B) : Colors.white,
            shape: _merekam ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: _merekam ? BorderRadius.circular(6) : null,
          ),
        ),
      ),
    );
  }
}
