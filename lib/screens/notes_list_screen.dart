// screens/notes_list_screen.dart
// Halaman untuk menampilkan daftar catatan (Dashboard)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../services/user_service.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];
  int? userId;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('currentUser');
    
    if (currentUser != null) {
      userId = await UserService.getUserId(currentUser);
      username = currentUser;
      if (mounted) {
        _loadNotes();
      }
    }
  }

  Future<void> _loadNotes() async {
    if (userId != null) {
      List<Note> loadedNotes = await NoteService.getAllNotes(userId!);
      setState(() {
        notes.clear(); // Membersihkan daftar sebelum menambahkan yang baru
        notes.addAll(loadedNotes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (username != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(username: username!),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Header dengan jumlah catatan dan ringkasan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.lightBlue[50]!],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $username!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${notes.length} catatan tersedia',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Ringkasan statistik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(Icons.book, 'Total', notes.length.toString()),
                    _buildStatCard(Icons.edit, 'Hari Ini', _getTodayNotesCount().toString()),
                    _buildStatCard(Icons.check, 'Terbaru', _getLatestNoteTitle()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Daftar catatan
          Expanded(
            child: notes.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Belum ada catatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tambahkan catatan pertama Anda dengan menekan tombol +',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotes,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        Note note = notes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(note.date), // Format tanggal yang lebih baik
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  note.content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteFormScreen(
                                          note: note,
                                          userId: userId!,
                                          onSave: (updatedNote) {
                                            setState(() {
                                              // Update catatan dalam daftar
                                              int noteIndex = notes.indexWhere(
                                                  (n) => n.id == updatedNote.id);
                                              if (noteIndex != -1) {
                                                notes[noteIndex] = updatedNote;
                                              } else {
                                                // Jika tidak ditemukan, mungkin ini adalah catatan baru
                                                notes.insert(0, updatedNote);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    // Konfirmasi penghapusan
                                    bool? confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Hapus Catatan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          content: Text(
                                            'Apakah Anda yakin ingin menghapus catatan "${note.title}"?',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text(
                                                'Batal',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmed == true) {
                                      await NoteService.deleteNote(note.id!);
                                      setState(() {
                                        notes.removeAt(index);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Note? newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteFormScreen(
                userId: userId!,
                onSave: (savedNote) {
                  setState(() {
                    notes.insert(0, savedNote); // Menambahkan di awal daftar
                  });
                },
              ),
            ),
          );

          // Tidak perlu menambahkan lagi di sini karena sudah ditangani oleh callback onSave
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Fungsi untuk menghitung jumlah catatan hari ini
  int _getTodayNotesCount() {
    if (notes.isEmpty) return 0;
    
    DateTime today = DateTime.now();
    int count = 0;
    
    for (Note note in notes) {
      DateTime noteDate = DateTime.parse(note.date);
      if (noteDate.day == today.day && 
          noteDate.month == today.month && 
          noteDate.year == today.year) {
        count++;
      }
    }
    
    return count;
  }

  // Fungsi untuk mendapatkan judul catatan terbaru
  String _getLatestNoteTitle() {
    if (notes.isEmpty) return '-';
    
    // Urutkan berdasarkan tanggal terbaru
    List<Note> sortedNotes = [...notes];
    sortedNotes.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    
    String title = sortedNotes[0].title;
    if (title.length > 10) {
      title = title.substring(0, 10) + '...';
    }
    return title;
  }

  // Fungsi untuk format tanggal
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString.substring(0, 10);
    }
  }

  // Widget untuk kartu statistik
  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}