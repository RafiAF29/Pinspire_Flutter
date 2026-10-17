# Pinspire

Kloning UI **Pinterest** untuk UTS Pemrograman Aplikasi Bergerak.
Nama aplikasi diplesetkan menjadi **Pinspire**.

| Lapisan   | Teknologi                          |
|-----------|------------------------------------|
| Frontend  | Flutter (Dart)                     |
| Backend   | Laravel (REST API) - tahap berikutnya |
| Database  | MySQL - tahap berikutnya           |

## Anggota Kelompok

| Nama | NIM |
|------|-----|
| (isi) | (isi) |

## Tahap 1 - Alur masuk (sudah selesai)

Splash -> Halaman awal (email / Google) -> **Masuk** (email terdaftar) atau **Registrasi**
(email baru: kata sandi -> nama -> tanggal lahir -> jenis kelamin -> negara -> minat -> "Pilihan yang bagus!") -> Beranda sementara.

Alur Google (3 langkah): Pilih akun -> jenis kelamin -> negara -> minat -> Beranda.

Semua tampilan memakai **mode terang** dan berbahasa Indonesia.

## Cara menjalankan

```bash
flutter pub get
flutter run            # pilih emulator / HP Android
```

Saat dijalankan di **Chrome / Windows / Linux / macOS**, aplikasi otomatis tampil di
dalam bingkai ukuran HP Android (392 x 852). Untuk menonaktifkannya, ubah
`AppConfig.bingkaiHpDiLaptop` di `lib/core/config/app_config.dart` menjadi `false`.

### Akun contoh untuk mencoba "Masuk"

- Email: `demo@pinspire.com`
- Kata sandi: `demo1234`

Email lain dianggap baru dan akan masuk ke alur registrasi. Data masih disimpan di
memori (hilang saat aplikasi ditutup) sampai backend Laravel tersambung.

## Struktur folder

```
lib/
  main.dart                  titik masuk aplikasi
  app.dart                   MaterialApp (tema terang + bingkai HP)
  core/
    config/                  pengaturan global
    theme/                   warna & tema
    utils/                   scroll behavior (drag mouse di laptop)
    widgets/                 widget bersama: tombol, kolom isian, logo, titik langkah, dll.
  features/
    splash/                  layar pembuka
    auth/
      models/                data registrasi, akun
      data/                  AuthRepository (mock), daftar negara & minat
      pages/                 halaman awal & semua langkah registrasi
      widgets/               sheet Masuk, dialog akun Google, roda pemilih tanggal
    home/                    beranda sementara
assets/images/               kolase, tumpukan kartu, foto minat
```

## Menyambungkan ke Laravel nanti

Semua akses data autentikasi lewat `AuthRepository`
(`lib/features/auth/data/auth_repository.dart`). Cukup buat `ApiAuthRepository`
yang memanggil REST API Laravel, lalu ganti objek `authRepository` di file itu.
Halaman UI tidak perlu diubah.

## Alur aplikasi (terintegrasi)

Splash → Welcome (Masuk / Daftar) → Beranda (feed pin) → detail pin
(suka ❤ + Simpan) → tab Disimpan (tekan lama pin untuk menghapus).
Ikon pengaturan di tab Disimpan berisi tombol **Keluar**.

Akun contoh untuk Masuk: `demo@pinspire.com` / `demo1234`.

### Gambar pin
Letakkan gambar feed/detail di `assets/images/` dengan nama yang dipakai
`lib/features/pin/data/pin_repository.dart` (mis. `dog.jpg`, `cat_cap.jpg`,
`bear_money.jpg`, `feed_music.jpg`, `cat1.jpg` …). Bila file belum ada,
pin tampil sebagai kotak berwarna pengganti.

### Alur Buat Pin
Beranda → tombol **+ Buat** → sheet "Mulai berkreasi sekarang" → **Pin** →
(hanya jika akun belum pernah "Allow all") layar izin + dialog akses foto/video →
galeri → pilih foto → **Berikutnya** → formulir **Buat Pin** (judul, deskripsi,
tautan, *Pilih papan* → *Buat papan* → halaman papan) → **Buat** → bar
"Menyelesaikan ..." → toast "Diterbitkan!". Pin yang terbit ikut tampil di tab Disimpan.

Galeri memakai foto contoh di `assets/images/galeri/` (bukan galeri HP asli).
Kode ada di `lib/features/create/`.
