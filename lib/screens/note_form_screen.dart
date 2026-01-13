// screens/note_form_screen.dart
// Halaman form untuk menambah atau mengedit catatan
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note; // Jika null, berarti menambah catatan baru
  final int userId; // ID user yang sedang login
  final Function(Note)? onSave; // Callback ketika catatan disimpan

  const NoteFormScreen({Key? key, this.note, required this.userId, this.onSave}) : super(key: key);

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Jika sedang mengedit catatan, isi form dengan data sebelumnya
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    setState(() {
      _isLoading = true;
    });

    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    // Validasi input
    if (title.isEmpty || content.isEmpty) {
      _showMessage('Judul dan isi catatan harus diisi!');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Buat objek catatan
    Note note;
    if (widget.note != null) {
      // Jika sedang mengedit
      note = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        date: DateTime.now().toString(),
        userId: widget.userId,
      );
    } else {
      // Jika sedang menambah baru
      note = Note(
        id: null, // ID akan di-generate oleh database
        title: title,
        content: content,
        date: DateTime.now().toString(),
        userId: widget.userId,
      );
    }

    // Simpan catatan
    Note savedNote = await NoteService.saveNote(note);

    // Panggil callback jika disediakan
    if (widget.onSave != null) {
      widget.onSave!(savedNote);
    }

    setState(() {
      _isLoading = false;
    });

    // Kembali ke halaman sebelumnya
    Navigator.pop(context, note);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? 'Edit Catatan' : 'Tambah Catatan Baru',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul catatan...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Tulis catatan Anda di sini...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        widget.note != null ? 'Update Catatan' : 'Simpan Catatan',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}