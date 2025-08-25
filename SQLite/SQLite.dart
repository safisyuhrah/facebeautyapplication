// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      userid INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone INTEGER NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    )
    ''';

    const bookingTable = '''
    CREATE TABLE beautybook (
      bookid INTEGER PRIMARY KEY AUTOINCREMENT,
      userid INTEGER NOT NULL,
      bookdate TEXT NOT NULL,
      booktime TEXT NOT NULL,
      appointmentdate TEXT NOT NULL,
      appointmenttime TEXT NOT NULL,
      facebeautypackage TEXT NOT NULL,
      numguest INTEGER NOT NULL,
      packageprice REAL NOT NULL,
      FOREIGN KEY (userid) REFERENCES users(userid)
    )
    ''';

    const reviewsTable = '''
    CREATE TABLE reviews (
      reviewid INTEGER PRIMARY KEY AUTOINCREMENT,
      userid INTEGER NOT NULL,
      rating INTEGER NOT NULL,
      review TEXT NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (userid) REFERENCES users(userid)
    )
    ''';

    await db.execute(userTable);
    await db.execute(bookingTable);
    await db.execute(reviewsTable);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
