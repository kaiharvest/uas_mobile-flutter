// models/user_model.dart
class User {
  final int? id;
  final String username;
  final String password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Konversi dari Map ke User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Konversi dari User ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}