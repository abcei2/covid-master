import 'dart:async';
import 'dart:io' as io;
import 'package:covid/models/Answer.dart';
import 'package:covid/models/Result.dart';
import 'package:covid/models/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "covid.main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, syncData INTEGER, genero INTEGER, birthDay TEXT, latitude TEXT, longitude TEXT, deviceId text NULL,  firstName TEXT, lastName TEXT, email TEXT,  phone TEXT, numberIdentification TEXT, principal INTEGER)");
    await db.execute(
        "CREATE TABLE answer(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, idResult INTEGER, syncData INTEGER, idUser INTEGER, firstName TEXT, lastName TEXT, question TEXT, answer TEXT)");
    await db.execute(
        "CREATE TABLE result(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, picture BLOB, latitude TEXT, longitude TEXT, syncData INTEGER, idUser INTEGER, firstName TEXT, lastName TEXT, result TEXT, shootingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> saveAnswer(Answer answer) async {
    var dbClient = await db;
    int res = await dbClient.insert("answer", answer.toMap());
    return res;
  }

  Future<int> saveResult(Result result) async {
    var dbClient = await db;
    int res = await dbClient.insert("result", result.toMap());
    return res;
  }

  Future<User> getUserId(id) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM User WHERE id = ?', [id]);
    // print(list);
    if (list.length == 0) {
      return null;
    } else {
      var user;
      for (int i = 0; i < list.length; i++) {
        user = new User(
            deviceId: list[i]["deviceId"],
            id: list[i]["id"],
            firstName: list[i]["firstName"],
            lastName: list[i]["lastName"],
            email: list[i]["email"],
            phone: list[i]["phone"],
            numberIdentification: list[i]["numberIdentification"],
            principal: list[i]["principal"],
            birthDay: list[i]["birthDay"].toString(),
            genero: list[i]["genero"].toString());
      }
      return user;
    }
  }

  Future<Result> getResultId(id) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM Result WHERE id = ?', [id]);
    // print(list);
    if (list.length == 0) {
      return null;
    } else {
      var result;
      for (int i = 0; i < list.length; i++) {
        result = new Result(
            id: list[i]["id"].toString(),
            idUser: list[i]["idUser"],
            firstName: list[i]["firstName"],
            lastName: list[i]["lastName"],
            result: list[i]["result"],
            syncData: list[i]["syncData"],
            picture: list[i]["picture"],
            latitude: list[i]["latitude"],
            longitude: list[i]["longitude"]);
      }
      return result;
    }
  }

  Future getUser(id) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM User WHERE id = ? AND principal = 1', [id]);
    if (list.length == 0) {
      return [];
    } else {
      var user;
      for (int i = 0; i < list.length; i++) {
        user = new User(
            deviceId: list[i]["deviceId"],
            id: list[i]["id"],
            firstName: list[i]["firstName"],
            lastName: list[i]["lastName"],
            email: list[i]["email"],
            phone: list[i]["phone"],
            numberIdentification: list[i]["numberIdentification"],
            principal: list[i]["principal"],
            birthDay: list[i]["birthDay"].toString(),
            genero: list[i]["genero"].toString());
      }
      return user;
    }
  }

  Future getUserRowId(rowId) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM User WHERE rowid = ? ', [rowId]);
    if (list.length == 0) {
      return [];
    } else {
      var user;
      for (int i = 0; i < list.length; i++) {
        user = new User(
            deviceId: list[i]["deviceId"],
            id: list[i]["id"],
            firstName: list[i]["firstName"],
            lastName: list[i]["lastName"],
            email: list[i]["email"],
            phone: list[i]["phone"],
            numberIdentification: list[i]["numberIdentification"],
            principal: list[i]["principal"]);
      }
      return user;
    }
  }

  Future setSyncData(String id) async {
    var dbClient = await db;
    await dbClient
        .rawUpdate('UPDATE Result SET syncData = ? WHERE id = ?', [1, id]);
  }

  Future getUsers() async {
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery(
        'SELECT rowid, firstName, lastName, latitude, longitude, email, phone, numberIdentification, principal FROM User');
    if (lists.length == 0) {
      return [];
    } else {
      return lists;
    }
  }

  Future getResults() async {
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery('SELECT * FROM Result');
    if (lists.length == 0) {
      return [];
    } else {
      return lists;
    }
  }

  Future getDataResultSync() async {
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery(
        'SELECT *, Result.id AS idResult FROM Result JOIN User ON Result.idUser = User.id WHERE Result.syncData = 0');
    if (lists.length == 0) {
      return [];
    } else {
      return lists;
    }
  }

  Future getDataResultANSWERSync(idResult) async {
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery(
        'SELECT * FROM Answer  WHERE Answer.idResult = $idResult AND Answer.syncData = 0');
    if (lists.length == 0) {
      return [];
    } else {
      return lists;
    }
  }

  Future<int> deleteUser(idUser) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [idUser]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res = await dbClient.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);
    return res > 0 ? true : false;
  }

  Future<bool> updateResult(Result result) async {
    var dbClient = await db;
    int res = await dbClient.update("Result", result.toMap(),
        where: "id = ?", whereArgs: <int>[int.parse(result.id)]);
    return res > 0 ? true : false;
  }
}
