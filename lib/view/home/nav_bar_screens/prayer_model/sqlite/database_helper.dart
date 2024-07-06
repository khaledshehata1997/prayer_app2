import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModel.dart';
import 'package:prayer_app/view/home/nav_bar_screens/prayer_model/prayerModelCurrent.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    return await openDatabase(
      join(await getDatabasesPath(), 'prayer_database.db'),
      version: 2, // Increment the database version
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE prayers(
            day TEXT PRIMARY KEY,
            prayer1 INTEGER,
            prayer2 INTEGER,
            prayer3 INTEGER,
            prayer4 INTEGER,
            prayer5 INTEGER,
          )
          ''',
        );
        await db.execute(
          '''
          CREATE TABLE prayersCurrent(
            day TEXT PRIMARY KEY,
            prayer1 INTEGER,
            prayer2 INTEGER,
            prayer3 INTEGER,
            prayer4 INTEGER,
            prayer5 INTEGER,
            prayer6 INTEGER,
            prayer7 INTEGER,
            prayer8 INTEGER,
            prayer9 INTEGER,
            prayer10 INTEGER,
            prayer11 INTEGER,
            calculation INTEGER DEFAULT 0
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            '''
            CREATE TABLE prayersCurrent(
              day TEXT PRIMARY KEY,
              prayer1 INTEGER,
              prayer2 INTEGER,
              prayer3 INTEGER,
              prayer4 INTEGER,
              prayer5 INTEGER,
              prayer6 INTEGER,
              prayer7 INTEGER,
              prayer8 INTEGER,
              prayer9 INTEGER,
              prayer10 INTEGER,
              prayer11 INTEGER,
              calculation INTEGER DEFAULT 0
            )
            ''',
          );
        }
      },
    );
  }

  // Methods for prayers table
  Future<void> insertPrayer(PrayerModel prayer) async {
    final db = await database;
    await db.insert(
      'prayers',
      prayer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PrayerModel?> getPrayer(String day) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayers',
      where: 'day = ?',
      whereArgs: [day],
    );

    if (maps.isNotEmpty) {
      return PrayerModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updatePrayer(PrayerModel prayer) async {
    final db = await database;
    await db.update(
      'prayers',
      prayer.toMap(),
      where: 'day = ?',
      whereArgs: [prayer.day],
    );
  }

  // Methods for prayersCurrent table
  Future<void> insertPrayerCurrent(PrayerCurrent prayer) async {
    final db = await database;
    await db.insert(
      'prayersCurrent',
      prayer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PrayerCurrent?> getPrayerCurrent(String day) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayersCurrent',
      where: 'day = ?',
      whereArgs: [day],
    );

    if (maps.isNotEmpty) {
      return PrayerCurrent.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updatePrayerCurrent(PrayerCurrent prayer) async {
    final db = await database;
    await db.update(
      'prayersCurrent',
      prayer.toMap(),
      where: 'day = ?',
      whereArgs: [prayer.day],
    );
  }
}
