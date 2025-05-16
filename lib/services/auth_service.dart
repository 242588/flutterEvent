import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  static Database? _database;

  AuthService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("event_app.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');
  }

  Future<void> registerUser(User user) async {
    final db = await instance.database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> login(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
