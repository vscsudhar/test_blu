import 'package:sqflite/sqflite.dart';
import 'package:test_blu/db_helper/database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  //insert User

  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  insertUserData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //login Check
  checkUserData(table, userName, userPass) async {
    var db = await database;
    return await db?.query('user',
        where: "userName = ? AND password = ?",
        whereArgs: [userName, userPass]);
  }

  // read User

  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  // read single record by id
  readById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  // delete DataBy Id
  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$itemId");
  }

  deleteDatas() async {
    var db = await database;
    return await db?.delete('users', where: '1');
  }

  readByDateAndSession(table, dateTime, session) async {
    var connection = await database;
    return await connection?.query(table,
        where: "session = '$session' AND dateTime = ?", whereArgs: [dateTime]);
  }

  readByDate(table, dateTime) async {
    var connection = await database;
    return await connection?.query(table, where: "dateTime = '$dateTime'");
  }

  exportTableToCSV(tableName) async {
    var db = await database;
    return await db?.query(tableName);
  }
}
