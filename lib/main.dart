import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pinspire hanya dipakai dalam mode potret, seperti aplikasi aslinya.
  SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);

  // Mode terang: ikon status bar & navigasi berwarna gelap.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const PinspireApp());
}
