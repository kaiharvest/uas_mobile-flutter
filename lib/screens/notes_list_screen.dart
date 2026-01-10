// screens/notes_list_screen.dart
// Halaman untuk menampilkan daftar catatan
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../services/user_service.dart';
import 'note_form_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];
  int? userId;

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
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Hapus status login
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('currentUser');

              // Kembali ke halaman login
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          )
        ],
      ),
      body: notes.isEmpty
          ? Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add_outlined,
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
                padding: const EdgeInsets.all(16.0),
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
                        note.date,
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
}