import 'dart:async';

import 'package:furnitureshopping/model/cart_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database _database;

  DatabaseService();

  Future<Database> _init() async {
    return openDatabase(join(await getDatabasesPath(), "cart_database.db"),
        version: 1, onCreate: (db, version) {
      return db.execute('''CREATE TABLE carts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            productId TEXT,
            productName TEXT,
            productPrice TEXT,
            quantity INTEGER,
            url TEXT)''');
    });
  }

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await _init();
    return _database;
  }

  Future<int> insert(CartItem cartItem) async {
    final Database database = await db;
    int insert = await database.insert("carts", cartItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return insert;
  }

  Future<List<CartItem>> retrieve(String userId) async {
    print("hello   " + userId);
    final Database database = await db;
    var maps = await database.query("carts");
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]["id"],
        userID: maps[i]["userId"],
        productID: maps[i]["productId"],
        productName: maps[i]["productName"],
        productPrice: maps[i]["productPrice"],
        quantity: maps[i]["quantity"],
        url: maps[i]["url"],
      );
    }).where((element) => element.userID == userId).toList(growable: true);
  }

  Future<int> delete(int id) async {
    final Database database = await db;
    int deletedId =
        await database.delete("carts", where: "id = ?", whereArgs: [id]);
    return deletedId;
  }

  Future<int> deleteAllByUserId(String userId) async {
    final Database database = await db;
    int deletedId;
    try {
      deletedId = await database
          .delete("carts", where: "userId = ?", whereArgs: [userId]);
    } catch (e) {
      print(e.toString());
    }
    return deletedId;
  }
}
