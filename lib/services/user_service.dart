// services/user_service.dart
// Service untuk manajemen user menggunakan SQLite
import '../models/user_model.dart';
import '../helpers/database_helper.dart';

class UserService {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  // Mendaftarkan user baru
  static Future<void> registerUser(User user) async {
    await _dbHelper.insertUser(user);
  }

  // Mendapatkan user berdasarkan username
  static Future<User?> getUser(String username) async {
    return await _dbHelper.getUser(username);
  }

  // Memeriksa apakah user sudah terdaftar
  static Future<bool> isUserRegistered() async {
    return await _dbHelper.isUserRegistered();
  }

  // Memeriksa apakah username sudah digunakan
  static Future<bool> isUsernameExists(String username) async {
    final user = await _dbHelper.getUser(username);
    return user != null;
  }

  // Mendapatkan user_id berdasarkan username
  static Future<int?> getUserId(String username) async {
    return await _dbHelper.getUserId(username);
  }
}