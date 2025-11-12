import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/user_model.dart'; // pastikan path ini benar

class DbHelper {
  static Database? _database;
  static const String _dbName = 'manga_app_db.db';
  static const String _tableName = 'users';

  // Singleton Instance
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  // Getter untuk Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  // Inisialisasi Database
  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Membuat tabel
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        passwordHash TEXT NOT NULL,
        salt TEXT NOT NULL,
        role TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // --- Versi Lama (Masih Bisa Dipakai Jika Butuh) ---
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(_tableName, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserMapByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  // --- 🔥 Versi Baru untuk AuthService ---
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(_tableName, user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}
