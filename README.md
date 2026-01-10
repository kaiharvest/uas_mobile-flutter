# Daily Notes App - Dokumentasi

## Deskripsi Aplikasi
Daily Notes App adalah aplikasi mobile sederhana yang dibuat dengan Flutter untuk mencatat kegiatan harian. Aplikasi ini memiliki fitur login lokal dan manajemen catatan harian (CRUD) yang disimpan secara lokal di perangkat pengguna.

## Fitur-fitur Utama
1. **Register & Login Lokal**:
   - Registrasi akun baru dengan username dan password
   - Login dengan username dan password yang telah terdaftar
   - Data login disimpan menggunakan SharedPreferences
   - Login otomatis jika sebelumnya sudah login

2. **Manajemen Catatan Harian**:
   - Membuat catatan baru (Create)
   - Melihat daftar catatan (Read)
   - Mengedit catatan yang sudah ada (Update)
   - Menghapus catatan (Delete)
   - Setiap catatan memiliki judul, isi, dan tanggal

3. **Logout**:
   - Tombol logout untuk menghapus status login
   - Mengembalikan pengguna ke halaman login

## Struktur Folder Project
```
lib/
├── main.dart                 # File utama aplikasi, berisi halaman login dan routing
├── models/
│   └── note_model.dart       # Model untuk representasi catatan
├── services/
│   └── note_service.dart     # Service untuk manajemen penyimpanan catatan
└── screens/
    ├── home_screen.dart      # Halaman utama aplikasi
    ├── register_screen.dart  # Halaman untuk registrasi akun baru
    ├── notes_list_screen.dart # Halaman untuk menampilkan daftar catatan
    └── note_form_screen.dart  # Halaman form untuk menambah/mengedit catatan
```

## Cara Menjalankan Project

### Prasyarat
- Flutter SDK terinstal di sistem
- Android Studio/VS Code sebagai IDE
- Emulator Android atau perangkat fisik

### Instalasi
1. Clone atau buka project ini di direktori lokal
2. Jalankan perintah berikut di terminal:
```bash
flutter pub get
```
3. Untuk menjalankan aplikasi:
```bash
flutter run
```

### Build untuk Android
```bash
flutter build apk
```

## Cara Kerja Aplikasi

### 1. Proses Login
- Saat pertama kali membuka aplikasi, pengguna akan diarahkan ke halaman login
- Jika belum ada akun terdaftar, maka username dan password pertama kali akan digunakan sebagai akun baru
- Jika sudah ada akun terdaftar, maka aplikasi akan memverifikasi username dan password
- Setelah login berhasil, status login disimpan di SharedPreferences dan pengguna diarahkan ke halaman utama
- Jika aplikasi dibuka kembali, akan langsung masuk ke halaman utama jika sebelumnya sudah login

### 2. Manajemen Catatan
- Di halaman utama, pengguna dapat melihat daftar catatan yang sudah dibuat
- Untuk menambah catatan baru, pengguna dapat menekan tombol floating action button (+)
- Untuk mengedit catatan, pengguna dapat menekan tombol edit (ikon pensil) di setiap item catatan
- Untuk menghapus catatan, pengguna dapat menekan tombol delete (ikon tempat sampah) di setiap item catatan
- Semua data catatan disimpan secara lokal menggunakan SharedPreferences

### 3. Proses Logout
- Pengguna dapat logout dengan menekan tombol logout (ikon keluar) di app bar
- Status login akan dihapus dari SharedPreferences
- Pengguna akan diarahkan kembali ke halaman login

## Teknologi yang Digunakan
- **Flutter**: Framework untuk pengembangan aplikasi mobile
- **Dart**: Bahasa pemrograman utama
- **SQLite**: Database lokal untuk menyimpan data pengguna dan catatan
- **SharedPreferences**: Untuk menyimpan status login sementara

## Arsitektur Aplikasi
- **StatefulWidget**: Digunakan untuk komponen yang memiliki state yang berubah-ubah
- **setState()**: Digunakan untuk memperbarui tampilan ketika state berubah
- **Model**: Struktur data untuk catatan
- **Service**: Logika bisnis untuk manajemen data
- **Screen/View**: Tampilan antarmuka pengguna

## Penyimpanan Data
- Data login (username, password, status login) disimpan di SharedPreferences
- Data catatan disimpan dalam bentuk list string di SharedPreferences
- Setiap catatan di-encode ke format JSON sebelum disimpan# uas_mobile-flutter
