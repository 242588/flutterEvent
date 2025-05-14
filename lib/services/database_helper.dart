import 'package:projetv1/models/event.dart';
import 'package:projetv1/models/feedback_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Méthode pour mettre à jour un événement dans la base de données
  Future<int> update(Event event) async {
    final db = await database;

    // Mettre à jour l'événement dans la table 'events'
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
  final db = await database;
  return await db.delete(
    'events',
    where: 'id = ?',
    whereArgs: [id],
  );
}





  
  Future _createDB(Database db, int version) async {

    // Créer la table Feedbacks
await db.execute('''
  CREATE TABLE IF NOT EXISTS feedbacks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    eventId INTEGER,
    rating INTEGER,
    comment TEXT,
    date TEXT,
    FOREIGN KEY(userId) REFERENCES users(id),
    FOREIGN KEY(eventId) REFERENCES events(id)
  )
''');


     // 👇 Ajoute cette table reservations
  await db.execute('''
    CREATE TABLE reservations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      eventId INTEGER NOT NULL,
      numberOfSeats INTEGER NOT NULL,
      reservationDate TEXT NOT NULL
    )
  ''');

    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        location TEXT NOT NULL,
        seats INTEGER NOT NULL,
        price REAL
      )
    ''');
  }

  // Méthode pour insérer un feedback
Future<void> insertFeedback(FeedbackModel feedback) async {
    final db = await instance.database;
    await db.insert(
      'feedbacks', // Nom de ta table feedback
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Ou `insertOrReplace`
    );
  }

// Méthode pour récupérer les feedbacks pour un événement
Future<List<FeedbackModel>> getFeedbacksForEvent(int eventId) async {
  final db = await database;
  final result = await db.query(
    'feedbacks',
    where: 'eventId = ?',
    whereArgs: [eventId],
  );
  return result.map((map) => FeedbackModel.fromMap(map)).toList();
}

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events');

    return maps.map((map) => Event.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
