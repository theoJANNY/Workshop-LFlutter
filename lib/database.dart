import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';

/// Management of the Database
class DatabaseBase{

  static Database _database;

  Future<Database> get database async{

    if (_database != null){
      return _database;
    }else{
      _database = await initDB();
      return _database;
    }
  }

  initDB() async{
    String PATH = (await getDatabasesPath()).toString();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    String path;
    if(Platform.isAndroid){
      if(await Permission.storage.status == PermissionStatus.granted) {
        path = join('$PATH', '.Seven4DataBase.db');
      }else{
        exitCode;
      }
    }else if(Platform.isIOS){
      path = join('$PATH', '.Seven4DataBase.db');
    }


    print(path);
    return await openDatabase(path, onCreate: (db, version){
      db.execute("CREATE TABLE User ("
          "id TEXT PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "telephone TEXT,"
          "create_at TEXT)");

    }, version: 1,);
  }

}