import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_crud.db');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE users (id INTEGER PRIMARY KEY, dateTime TEXT, center TEXT,customerId TEXT, weight TEXT, session TEXT, time TEXT)";
    await database.execute(sql);

    String sqlData =
        "CREATE TABLE user (id INTEGER PRIMARY KEY, dateTime TEXT, userName TEXT, password TEXT)";
    await database.execute(sqlData);
  }
  }
 