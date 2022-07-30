import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';

class DbHelper {
  static const int version = 1;
  static Database? db;

  ///Singleton pattern
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Future<Database?> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
      database.execute('CREATE TABLE lists ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'name TEXT,'
          'priority INTEGER'
          ')');
      database.execute('CREATE TABLE items ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
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
    await db!.execute(
        'INSERT INTO lists (name, priority) VALUES (?, ?)', ['Fruits', '2']);
    await db!.execute(
        'INSERT INTO items (idList, name, quantity) VALUES (1,"Apples", "2 kg")');
    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
    print('====length${lists.length}');
    print(lists.toString());
    print(items.toString());
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
      return ShoppingList(
        maps[i]['name'],
        maps[i]['priority'],
        id: maps[i]['id'],
      );
    });
  }

  static Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps =
        await db!.query('items', where: 'idList = ?', whereArgs: [idList]);
    return List.generate(
        maps.length,
        (i) => ListItem(
              maps[i]['idList'],
              maps[i]['name'],
              maps[i]['quantity'],
              maps[i]['note'],
              id: maps[i]['id'],
            ));
  }

  static Future<int> deleteList(ShoppingList list) async {
    int result = await db!.delete('lists', where: 'id=?', whereArgs: [list.id]);
    return result;
  }

  static Future<int> deleteItem(ListItem item) async {
    int result = await db!.delete('items', where: 'id=?', whereArgs: [item.id]);
    return result;
  }
}
