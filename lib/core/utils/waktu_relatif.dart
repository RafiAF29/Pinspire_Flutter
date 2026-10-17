/// Teks singkat "3 menit" / "2 jam" / "4 hari" untuk kartu papan.
String waktuRelatif(DateTime waktu) {
  final selisih = DateTime.now().difference(waktu);
  if (selisih.inMinutes < 1) return '1 menit';
  if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit';
  if (selisih.inHours < 24) return '${selisih.inHours} jam';
  if (selisih.inDays < 30) return '${selisih.inDays} hari';
  if (selisih.inDays < 365) return '${selisih.inDays ~/ 30} bulan';
  return '${selisih.inDays ~/ 365} tahun';
}
