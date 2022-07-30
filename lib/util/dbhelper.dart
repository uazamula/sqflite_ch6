import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';

class DbHelper {
  static const int version = 1;
  static Database? db;

  static Future<Database?> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
      database.execute('CREATE TABLE lists ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'priority INTEGER'
          ')');
      database.execute('CREATE TABLE items ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'idList INTEGER,'
          'name TEXT,'
          'quantity TEXT,'
          'note TEXT,'
          'FOREIGN KEY(idList) REFERENCES lists(id)'
          ')');
    }, version: version);
    return db;
  }

  Future testDb() async {
    db = await openDb();
    await db!.execute('INSERT INTO lists (name, priority) VALUES ("Fruit", 2)');
    await db!.execute(
        'INSERT INTO items (name, quantity) VALUES ("Apples", "2 kg")');
    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
    print(lists[8].toString());
    print(items[8].toString());
  }

  static Future<int> insertList(ShoppingList list) async {
    int? id = await db!.insert(
      'lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> insertItem(ListItem item) async {
    int? id = await db!.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');
    return List.generate(maps.length, (i) {
      return ShoppingList(maps[i]['name'], maps[i]['priority']);
    });
  }
}
