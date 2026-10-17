import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../pin/data/saved_store.dart';
import '../../pin/models/pin.dart';
import 'board_store.dart';

enum PublishFase { diam, mengunggah, terbit }

/// Status unggah pin: bar "Menyelesaikan ..." lalu toast "Diterbitkan!".
/// Nanti startUnggah() diganti upload ke API (POST /pins, multipart).
class PublishStore extends ChangeNotifier {
  PublishStore._();
  static final PublishStore instance = PublishStore._();

  static const durasiUnggah = Duration(milliseconds: 2600);
  static const durasiToast = Duration(milliseconds: 4500);
  static const _langkah = Duration(milliseconds: 50);

  PublishFase _fase = PublishFase.diam;
  double _progres = 0;
  Pin? _pin;
  Timer? _timer;

  PublishFase get fase => _fase;
  double get progres => _progres;
  Pin? get pin => _pin;

  void mulai(Pin pin, {Board? papan}) {
    _timer?.cancel();
    _pin = pin;
    _fase = PublishFase.mengunggah;
    _progres = 0;
    notifyListeners();

    _timer = Timer.periodic(_langkah, (t) {
      _progres += _langkah.inMilliseconds / durasiUnggah.inMilliseconds;
      if (_progres >= 1) {
        t.cancel();
        _selesai(pin, papan);
      } else {
        notifyListeners();
      }
    });
  }

  void _selesai(Pin pin, Board? papan) {
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
