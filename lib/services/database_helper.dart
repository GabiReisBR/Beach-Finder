import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/beach.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'beaches.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE beaches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        description TEXT,
        imagePath TEXT,
        rating REAL,
        priceLevel INTEGER,
        childrenFriendly INTEGER,
        surferFriendly INTEGER
      )
    ''');
  }

  Future<void> addBeach(Beach beach) async {
    final db = await database;
    await db.insert('beaches', beach.toMap());
  }

  Future<void> updateBeach(Beach beach) async {
    final db = await database;
    await db.update(
      'beaches',
      beach.toMap(),
      where: 'id = ?',
      whereArgs: [beach.id],
    );
  }

  Future<void> deleteBeach(int id) async {
    final db = await database;
    await db.delete('beaches', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Beach>> getBeaches() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('beaches');
    return List.generate(maps.length, (i) {
      return Beach.fromMap(maps[i]);
    });
  }
}
