import 'package:mp5/model/weatherLocation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'weather_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE weather_locations(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, temperature REAL, weather_condition TEXT)''');
  }

  Future<void> insertWeatherLocation(WeatherLocation location) async {
    final Database db = await database;

    await db.insert(
      'weather_locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeatherLocation>> getWeatherLocations() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weather_locations');

    return List.generate(maps.length, (index) {
      return WeatherLocation(
        id: maps[index]['id'],
        name: maps[index]['name'],
        temperature: maps[index]['temperature'],
        weatherCondition: maps[index]['weather_condition'],
      );
    });
  }

  Future<void> deleteWeatherLocation(int id) async {
    final Database db = await database;

    await db.delete(
      'weather_locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
