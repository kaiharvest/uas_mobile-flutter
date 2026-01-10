// screens/home_screen.dart
// Halaman utama aplikasi setelah login
import 'package:flutter/material.dart';
import 'notes_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah pengguna kembali ke halaman login dengan tombol back
        return false;
      },
      child: const NotesListScreen(), // Gunakan halaman daftar catatan sebagai halaman utama
    );
  }
}