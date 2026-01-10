// services/note_service.dart
// Service untuk manajemen penyimpanan catatan menggunakan SQLite
import '../models/note_model.dart';
import '../helpers/database_helper.dart';

class NoteService {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  // Mendapatkan semua catatan berdasarkan user_id
  static Future<List<Note>> getAllNotes(int userId) async {
    return await _dbHelper.getAllNotes(userId);
  }

  // Menyimpan catatan baru
  static Future<void> saveNote(Note note) async {
    if (note.id != null) {
      // Jika id sudah ada, berarti update
      await _dbHelper.updateNote(note);
    } else {
      // Jika id null, berarti insert baru
      await _dbHelper.insertNote(note);
    }
  }

  // Menghapus catatan berdasarkan ID
  static Future<void> deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
  }
  
  // Mendapatkan ID unik untuk catatan baru
  // (tidak perlu karena SQLite akan auto-generate)
}