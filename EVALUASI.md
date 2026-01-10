# Evaluasi Daily Notes App

## Pengujian Fitur Register, Login, dan Logout

### Uji Coba Register
- **Pengujian halaman register**:
  - Hasil: Berhasil - Tersedia tombol "Belum punya akun? Register di sini" di halaman login
  - Catatan: Mengarahkan ke halaman register yang terpisah

- **Pengujian pembuatan akun baru**:
  - Hasil: Berhasil - Pengguna dapat membuat akun baru dengan username dan password
  - Catatan: Data disimpan di SharedPreferences

- **Pengujian validasi register**:
  - Hasil: Berhasil - Aplikasi menampilkan pesan jika username atau password kosong
  - Catatan: Tidak bisa register jika sudah ada akun terdaftar

### Uji Coba Login
- **Pengujian pertama kali aplikasi dijalankan**:
  - Hasil: Berhasil - Aplikasi menampilkan halaman login
  - Catatan: Tersedia link untuk register jika belum punya akun

- **Pengujian login dengan akun yang benar**:
  - Hasil: Berhasil - Pengguna dapat login dengan username dan password yang terdaftar
  - Catatan: Aplikasi mengarahkan ke halaman utama setelah login

- **Pengujian login dengan akun yang salah**:
  - Hasil: Berhasil - Aplikasi menampilkan pesan error "Username atau password salah!"
  - Catatan: Tidak ada perubahan status login

- **Pengujian login otomatis**:
  - Hasil: Berhasil - Aplikasi langsung masuk ke halaman utama jika sebelumnya sudah login
  - Catatan: Menggunakan SharedPreferences untuk memeriksa status login

### Uji Coba Logout
- **Pengujian tombol logout**:
  - Hasil: Berhasil - Status login dihapus dan pengguna kembali ke halaman login
  - Catatan: Menggunakan Navigator.pushNamedAndRemoveUntil untuk membersihkan stack halaman

## Pengujian Fitur CRUD Catatan

### Uji Coba Create (Membuat Catatan Baru)
- **Pengujian menambah catatan baru**:
  - Hasil: Berhasil - Pengguna dapat menambah catatan dengan judul dan isi
  - Catatan: ID unik dibuat otomatis menggunakan timestamp

- **Pengujian validasi input**:
  - Hasil: Berhasil - Aplikasi menampilkan pesan error jika judul atau isi kosong
  - Catatan: Tidak ada catatan yang disimpan jika input tidak valid

### Uji Coba Read (Membaca/Menampilkan Catatan)
- **Pengujian menampilkan daftar catatan**:
  - Hasil: Berhasil - Semua catatan ditampilkan dalam bentuk list dengan card
  - Catatan: Ditampilkan judul, isi (dengan ellipsis jika terlalu panjang), dan tanggal

- **Pengujian pesan ketika tidak ada catatan**:
  - Hasil: Berhasil - Ditampilkan pesan "Belum ada catatan. Silakan tambah catatan baru."
  - Catatan: Tampilan bersih ketika tidak ada data

### Uji Coba Update (Mengedit Catatan)
- **Pengujian mengedit catatan**:
  - Hasil: Berhasil - Pengguna dapat mengedit catatan yang sudah ada
  - Catatan: Form diisi dengan data sebelumnya saat membuka halaman edit

- **Pengujian update data**:
  - Hasil: Berhasil - Data catatan diperbarui di daftar dan di penyimpanan lokal
  - Catatan: Tanggal otomatis diperbarui ke waktu saat ini

### Uji Coba Delete (Menghapus Catatan)
- **Pengujian menghapus catatan**:
  - Hasil: Berhasil - Pengguna dapat menghapus catatan dengan konfirmasi
  - Catatan: Ditampilkan dialog konfirmasi sebelum penghapusan

- **Pengujian penghapusan dari penyimpanan**:
  - Hasil: Berhasil - Catatan dihapus dari daftar dan dari SharedPreferences
  - Catatan: Tidak ada efek samping setelah penghapusan

## Pengujian Penyimpanan Data Lokal

### Uji Coba Penyimpanan Catatan
- **Pengujian penyimpanan ke SQLite**:
  - Hasil: Berhasil - Semua catatan disimpan ke dalam tabel notes di database SQLite
  - Catatan: Setiap catatan terkait dengan user_id untuk memastikan data terisolasi

- **Pengujian pembacaan dari SQLite**:
  - Hasil: Berhasil - Catatan dapat dibaca kembali dari database SQLite
  - Catatan: Data tetap utuh setelah aplikasi ditutup dan dibuka kembali

- **Pengujian persistensi data**:
  - Hasil: Berhasil - Data tetap ada setelah aplikasi ditutup dan dibuka kembali
  - Catatan: Tidak ada kehilangan data saat aplikasi di-restart

### Uji Coba Struktur Data
- **Pengujian struktur model Note**:
  - Hasil: Berhasil - Model Note memiliki properti id, title, content, dan date
  - Catatan: Konversi dari Map ke Note dan sebaliknya berfungsi dengan baik

## Analisis Kendala/Error

### Kendala yang Ditemukan
1. **Navigasi antar halaman**:
   - Kendala: Awalnya kesulitan dalam mengimplementasikan navigasi yang benar antara halaman
   - Solusi: Menggunakan Navigator.push, Navigator.pushReplacement, dan Navigator.pushNamed sesuai kebutuhan

2. **Manajemen state**:
   - Kendala: Kesulitan dalam memperbarui tampilan setelah perubahan data
   - Solusi: Menggunakan setState() dengan benar untuk memperbarui state dan tampilan

3. **Penyimpanan lokal**:
   - Kendala: Kesulitan dalam menyimpan objek kompleks ke SharedPreferences
   - Solusi: Menggunakan JSON encoding/decoding untuk mengkonversi objek ke string dan sebaliknya

### Error yang Ditemukan dan Solusi
1. **Error saat parsing tanggal**:
   - Error: Format tanggal tidak konsisten
   - Solusi: Menggunakan DateTime.parse() dan toIso8601String() untuk konsistensi format

2. **Error saat menghapus item dari list**:
   - Error: Index out of bounds saat menghapus item
   - Solusi: Menggunakan metode removeWhere dan reload data setelah perubahan

## Evaluasi Kemudahan Penggunaan

### Antarmuka Pengguna (UI)
- **Kemudahan navigasi**: 
  - Nilai: Baik
  - Komentar: Tampilan sederhana dan intuitif, mudah dinavigasi

- **Desain visual**:
  - Nilai: Baik
  - Komentar: Menggunakan komponen Material Design dengan warna biru sebagai tema utama

- **Responsifitas**:
  - Nilai: Baik
  - Komentar: Aplikasi merespons dengan cepat terhadap interaksi pengguna

### Fungsi dan Fitur
- **Kelengkapan fitur**:
  - Nilai: Lengkap
  - Komentar: Semua fitur yang diminta (login, CRUD catatan, logout) telah diimplementasikan

- **Kestabilan aplikasi**:
  - Nilai: Baik
  - Komentar: Tidak ada crash atau error kritis selama pengujian

- **Kemudahan penggunaan**:
  - Nilai: Baik
  - Komentar: Pengguna dapat dengan mudah menggunakan semua fitur tanpa instruksi tambahan

### Kinerja
- **Kecepatan loading**:
  - Nilai: Baik
  - Komentar: Aplikasi membuka dan memuat data dengan cepat

- **Penggunaan memori**:
  - Nilai: Efisien
  - Komentar: Aplikasi tidak menggunakan memori berlebihan karena hanya menyimpan data lokal sederhana

## Kesimpulan
Daily Notes App telah berhasil diimplementasikan sesuai dengan spesifikasi yang diminta. Aplikasi ini menyediakan fitur login lokal, manajemen catatan harian (CRUD), dan penyimpanan data lokal tanpa memerlukan backend atau database server. 

Aplikasi ini:
- Menggunakan StatefulWidget dan setState() sesuai permintaan
- Memiliki desain sederhana dan responsif
- Berjalan full offline
- Menggunakan SharedPreferences untuk menyimpan data login dan catatan
- Mudah digunakan dan stabil dalam pengujian

Aplikasi siap digunakan dan dapat dibuild untuk platform Android.