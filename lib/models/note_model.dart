// models/note_model.dart
// Model untuk representasi catatan harian
class Note {
  final int? id;
  final String title;
  final String content;
  final String date;
  final int userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.userId,
  });

  // Konversi dari Map ke Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      userId: map['user_id'],
    );
  }

  // Konversi dari Note ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'user_id': userId,
    };
  }
}