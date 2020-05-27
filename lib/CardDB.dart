import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'CardModel.dart';
import 'database.dart';


class UserDB{

  Future<Database> get database async{
    var database = DatabaseBase();
    return database.database;
  }

  Future<List<User>> getUser() async{
    var userDB = await database;
    List<Map<String, dynamic>> maps = await userDB.rawQuery("SELECT * FROM User");
    return List.generate(maps.length, (i) {
      return User(
        maps[i]['createdAt'],
        maps[i]['telephone'],
        maps[i]['first_name'],
        maps[i]['last_name'],
        id: maps[i]['id'],
      );
    });
  }

  updateUser(User user) async{
    var userDB = await database;
    await userDB.rawUpdate("UPDATE User SET telephone = ?, first_name = ?, last_name = ? WHERE id = ?",
    [user.telephone, user.first_name, user.last_name, user.id]);
  }

  Future<User> insertUser(User user) async{
    var userDB = await database;
    await userDB.rawInsert("INSERT INTO User (id, first_name, last_name, telephone, create_at) "
        "VALUES ('"+user.id+"','"+user.first_name+"','"+
        user.last_name+"','"+user.telephone+"','"+user.createdAt+"')");
    return user;
  }

  Future<int> deleteUser(User user) async{
    var userDB = await database;
    int count = 0;
    count = await userDB.rawDelete("DELETE FROM User WHERE id = ?",[user.id]);
    return count;
  }
}
