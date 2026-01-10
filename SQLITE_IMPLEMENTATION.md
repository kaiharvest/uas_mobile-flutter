# Implementasi Database SQLite

## Struktur Database

Aplikasi Daily Notes App menggunakan SQLite sebagai database lokal untuk menyimpan data pengguna dan catatan. Struktur database terdiri dari dua tabel:

### 1. Tabel `users`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `username`: TEXT UNIQUE NOT NULL
- `password`: TEXT NOT NULL

### 2. Tabel `notes`
- `id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `title`: TEXT NOT NULL
- `content`: TEXT NOT NULL
- `date`: TEXT NOT NULL
- `user_id`: INTEGER NOT NULL (FOREIGN KEY ke tabel users)

## Arsitektur Data

### Model
- `User`: Mewakili data pengguna dengan id, username, dan password
- `Note`: Mewakili catatan dengan id, title, content, date, dan user_id

### Helper
- `DatabaseHelper`: Kelas yang mengelola operasi database seperti pembuatan tabel, insert, update, delete, dan query

### Service
- `UserService`: Menyediakan metode untuk operasi terkait pengguna (register, login, cek user)
- `NoteService`: Menyediakan metode untuk operasi terkait catatan (create, read, update, delete)

## Keunggulan SQLite dibanding SharedPreferences

1. **Struktur Data**: SQLite mendukung struktur data relasional yang lebih kompleks
2. **Query**: Mendukung query SQL untuk pencarian dan filter data
3. **Integritas Data**: Mendukung constraint dan relasi antar tabel
4. **Skalabilitas**: Lebih baik untuk menyimpan data dalam jumlah besar
5. **Isolasi Data**: Setiap pengguna hanya bisa mengakses catatannya sendiri

## Keamanan

- Data pengguna dan catatan terisolasi berdasarkan user_id
- Tidak ada data sensitif yang disimpan dalam bentuk plain text (meskipun untuk implementasi ini password disimpan secara sederhana, dalam produksi sebaiknya di-hash)

## Persistensi

- Data disimpan secara permanen di perangkat pengguna
- Tidak hilang meskipun aplikasi ditutup atau perangkat direstart
- Data hanya bisa diakses oleh aplikasi itu sendiri