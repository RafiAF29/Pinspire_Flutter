/// Pengaturan lanjutan satu Pin (halaman "Pengaturan Lanjutan" di Buat Pin).
/// Objek yang sama diubah langsung oleh halamannya.
/// Nanti ikut dikirim ke API saat Pin diterbitkan.
class PengaturanPin {
  bool izinkanKomentar = true;
  String teksAlt = '';
  bool tampilkanProdukSerupa = true;
  bool dimodifikasiAi = false;
  bool orangBuatanAi = false;
}
