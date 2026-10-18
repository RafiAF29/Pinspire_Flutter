/// Semua teks tampilan (Bahasa Indonesia) ada di sini.
/// Mau ganti kata? Cukup ubah di file ini.
class AppStrings {
  AppStrings._();

  // Bottom nav
  static const navHome = 'Beranda';
  static const navSearch = 'Cari';
  static const navCreate = 'Buat';
  static const navInbox = 'Kotak Masuk';
  static const navSaved = 'Disimpan';

  // Halaman detail pin
  static const save = 'Simpan';
  static const saved = 'Disimpan';
  static const profile = 'Profil';
  static const liked = 'Suka';
  static const aiModified = 'Dimodifikasi AI';
  static const seeTranslation = 'Lihat terjemahan';
  static const moreToExplore = 'Lainnya untuk dijelajahi';

  // Halaman Disimpan
  static const tabPins = 'Pin';
  static const tabBoards = 'Papan';
  static const tabCollages = 'Kolase';
  static const searchPins = 'Cari di Pin Anda';
  static const favourites = 'Favorit';
  static const createdByYou = 'Dibuat oleh Anda';
  static const removeFromSaved = 'Hapus dari Disimpan';
  static const settings = 'Pengaturan';
  static const logout = 'Keluar';
  static String pinsSaved(int n) => '$n Pin disimpan';

  // Buat (plus) -> pilihan
  static const createSheetTitle = 'Mulai berkreasi sekarang';
  static const createPin = 'Pin';
  static const createCollage = 'Kolase';
  static const createBoard = 'Papan';

  // Izin akses galeri
  static const permTitle = 'Izinkan akses untuk melanjutkan';
  static const permBody =
      'Untuk membuat Pin, Pinspire membutuhkan izin untuk mengakses galeri '
      'Anda guna mengunggah media dan foto dari perangkat ini.';
  static const permGallery = 'Akses galeri';
  static const permButton = 'Izinkan akses';
  // Dialog sistem Android (memang berbahasa Inggris di screenshot).
  static const permDialog =
      'Allow Pinspire to access photos and videos on this device?';
  static const permLimited = 'Allow limited access';
  static const permAll = 'Allow all';
  static const permDeny = "Don't allow";

  // Izin kamera & audio
  static const permCamTitle = 'Gunakan kamera Anda';
  static const permCamBody =
      'Izinkan akses kamera, audio, dan galeri untuk merekam video.';
  static const permCamera = 'Akses kamera';
  static const permAudio = 'Akses audio';
  // Dialog sistem Android (berbahasa Inggris, sesuai screenshot).
  static const permCameraDialog =
      'Allow Pinspire to take pictures and record video?';
  static const permAudioDialog = 'Allow Pinspire to record audio?';
  static const permWhileUsing = 'While using the app';
  static const permOnlyOnce = 'Only this time';

  static const camNone = 'Kamera tidak ditemukan di perangkat ini.';
  static const camDenied =
      'Izin kamera/mikrofon ditolak. Aktifkan lewat pengaturan perangkat '
      'atau browser, lalu coba lagi.';
  static const camError = 'Kamera tidak dapat dibuka.';
  static const camRetry = 'Coba lagi';

  // Kamera & editor
  static const camRecordUpTo = 'Rekam hingga 5 m';
  static const camPortrait = 'Potret';
  static const camSearchTitle = 'Cari dengan kamera';
  static const visualSearchTitle = 'Hasil pencarian foto';
  static const visualSearchSimilar = 'Ide serupa';
  static const camTimer = 'Pengatur waktu';
  static const camFlash = 'Lampu kilat';
  static const camFlip = 'Balik';
  static const editSize = 'Ukuran';
  static const editMedia = 'Media';
  static const editText = 'Teks';
  static const editSticker = 'Stiker';
  static const editDraw = 'Gambar';
  static const editColor = 'Warna';

  // Pemilih galeri
  static const multiAssets = 'Beberapa aset akan membuat satu video';
  static const allPhotos = 'Semua foto';
  static const next = 'Berikutnya';
  static const tabAll = 'Semua';
  static const tabVideo = 'Video';
  static const tabPhoto = 'Foto';

  // Buat Pin
  static const createPinTitle = 'Buat Pin';
  static const fieldTitle = 'Judul';
  static const hintTitle = 'Beri tahu orang-orang isi Pin Anda';
  static const maxTitle = 'Maks 100 karakter';
  static const fieldDesc = 'Deskripsi';
  static const hintDesc = 'Deskripsikan Pin Anda';
  static const fieldLink = 'Tautan';
  static const hintLink = 'Tambahkan tautan Anda di sini';
  static const chooseBoard = 'Pilih papan';
  static const tagTopic = 'Beri tag topik';
  static const tagProduct = 'Berikan tag pada produk';
  static const advanced = 'Pengaturan Lanjutan';
  static const btnCreate = 'Buat';

  // Papan
  static const saveToBoard = 'Simpan ke papan';
  static const newBoard = 'Buat papan';
  static const boardName = 'Nama papan';
  static const boardNameHint = 'Namai papan Anda';
  static const boardPrivate = 'Jadikan papan ini privat';
  static const boardPrivateDesc =
      'Papan bersifat publik secara default dan dapat dilihat oleh siapa saja. '
      'Hanya kolaborator yang dapat melihat papan privat.';
  static const groupBoard = 'Papan kelompok';
  static const groupBoardDesc =
      'Undang kolaborator untuk bergabung dengan papan ini';
  static const privateBoard = 'Papan privat';
  static const moreIdeas = 'Ide lainnya';
  static const allSaves = 'Semua simpan';
  static const lastSaved = 'Terakhir disimpan';
  static const emptyBoard =
      'Belum ada yang disimpan. Simpan ide yang Anda sukai dan isi papan ini '
      'dengan apa yang menginspirasi Anda';
  static const arrange = 'Atur';
  static const add = 'Tambahkan';

  // Proses unggah
  static const finishing = 'Menyelesaikan ...';
  static const published = 'Diterbitkan! Ingin berbagi?';

  // Cari
  static const searchHint = 'Cari ide';
  static const cancel = 'Batal';
  static const ideasForYou = 'Ide-ide buat Anda';
  static const popularOnPinspire = 'Populer di Pinspire';
  static const lessAi = 'Lebih Sedikit AI';
  static const searchInYourPins = 'Cari di Pin Anda';

  // Profil
  static const created = 'Dibuat';
  static const savedTab = 'Disimpan';
  static const followers = 'pengikut';
  static const following = 'mengikuti';
  static const bioHint = 'Tambahkan bio singkat agar profil Anda menjadi khas Anda';
  static const editProfile = 'Edit profil';
  static const inspireWithPins = 'Beri inspirasi dengan Pin!';
  static const allPins = 'Semua Pin';
  static const done = 'Selesai';
  static const edit = 'Edit';
  static const name = 'Nama';
  static const username = 'Nama pengguna';
  static const about = 'Tentang';
  static const aboutHint = 'Ceritakan kisah Anda';
  static const website = 'Situs web';
  static const websiteHint =
      'Tambahkan tautan untuk mendorong lalu lintas ke situs Anda';
  static const layout = 'Tata Letak';
  static const showAllPins = 'Tampilkan Semua Pin';
  static const showAllPinsDesc =
      'Orang yang mengunjungi profil Anda akan dapat melihat koleksi semua '
      'Pin yang Anda simpan. Pin yang disimpan ke papan rahasia tidak akan '
      'terlihat.';
  static const profilePrivacy =
      'Jaga detail privasi Anda tetap pribadi. Informasi yang Anda tambahkan '
      'di sini dapat dilihat oleh siapa pun yang dapat melihat profil Anda.';

  // Disimpan > Papan & Kolase
  static const group = 'Group';
  static const private = 'Privat';
  static const recentlyDeleted = 'Baru-baru ini dihapus';
  static const restore = 'Pulihkan';
  static String deletedBoards(int n) =>
      '$n papan, termasuk Pin mereka, akan dihapus secara permanen setelah 7 hari.';
  static const unorganizedIdeas = 'Ide belum diatur';
  static const organize = 'Atur';
  static const inProgress = 'Sedang berlangsung';
  static const createFirstCollage = 'Buat kolase pertama Anda';
  static const createFirstCollageDesc =
      'Gunting dan tempel bagian terbaik dari Pin favorit Anda untuk membuat '
      'sesuatu yang benar-benar baru.';
  static const createCollageBtn = 'Buat kolase';
  static const deleteBoard = 'Hapus papan';

  // Buat Pin: tag topik, tag produk, pengaturan lanjutan
  static const searchTopic = 'Cari topik';
  static const tagTopicDesc =
      'Beri tag topik terkait untuk menjangkau orang yang tertarik pada Pin '
      'seperti milik Anda. Orang tidak akan melihat topik Anda yang diberi tag.';
  static const selected = 'Dipilih';
  static const findPin = 'Cari Pin';
  static const useLink = 'Gunakan tautan';
  static const searchByProduct = 'Cari berdasarkan nama produk';
  static const productTooltip = 'Pin produk yang Anda simpan akan muncul di sini.';
  static const addProductLink = 'Tambahkan tautan produk';
  static const productLinkDesc =
      'Masukkan tautan ke halaman produk di situs peritel. Pin produk akan '
      'otomatis dibuat dan diberi tag di Pin Anda.';
  static const engagementSettings = 'Pengaturan keterlibatan';
  static const allowComments = 'Izinkan komentar';
  static const altText = 'Teks Alt';
  static const altTextHint = 'Jelaskan detail visual Pin Anda';
  static const altTextDesc =
      'Detail visual membantu pengguna pembaca layar memahami Pin Anda.';
  static const shoppingRecs = 'Rekomendasi belanja';
  static const showSimilarProducts = 'Tampilkan produk serupa';
  static const showSimilarProductsDesc =
      'Orang dapat berbelanja produk serupa dengan yang ditampilkan di Pin ini '
      'menggunakan pencarian visual.';
  static const shoppingRecsNote =
      'Rekomendasi belanja tidak tersedia untuk Pin dengan produk yang diberi '
      'tag atau label kemitraan berbayar.';
  static const aiDisclosure = 'Pengungkapan AI';
  static const markAiModified = 'Tandai sebagai dimodifikasi AI';
  static const markAiModifiedDesc =
      'Konten yang dibuat sepenuhnya atau sebagian dengan AI';
  static const showAiPeople = 'Menampilkan orang buatan AI';
  static const showAiPeopleDesc = 'Dalam Pin ini terdapat orang buatan AI';

  // Kotak Masuk
  static const inboxTitle = 'Kotak Masuk';
  static const messages = 'Pesan';
  static const seeAll = 'Lihat semua';
  static const inviteFriends = 'Undang teman-teman Anda';
  static const inviteFriendsDesc = 'Hubungkan untuk mulai mengobrol';
  static const updates = 'Pembaruan';
  static const updatesDesc =
      'Pembaruan menunjukkan aktivitas pada Pin dan papan Anda serta '
      'memberikan tips tentang topik yang bisa dijelajahi. Pembaruan akan '
      'segera hadir.';
  static const contacts = 'Kontak';
  static const editingYourProfile = 'Mengedit profil Anda';
  static const shareProfileLink = 'Bagikan tautan profil';
  static const copyLink = 'Salin Tautan';
  static const linkCopied = 'Tautan disalin';
  static const shareWhatsapp = 'WhatsApp';
  static const shareTelegram = 'Telegram';
  static const shareGoogleMessages = 'Pesan Google';
  static const shareInstagram = 'Instagram';
  static const shareGmail = 'Gmail';
  static const shareMessage = 'Pesan';
  static const shareMore = 'Lainnya';
  static String pinBoardCount(int pin, int papan) => '$pin Pin · $papan papan';
  static String shareVia(String app) => 'Membagikan lewat $app ...';

  // Tambahkan Pin ke papan & halaman papan
  static const addPins = 'Tambahkan Pin';
  static const removedToast = 'Dihapus!';
  static const publicBoard = 'Papan publik';
}
