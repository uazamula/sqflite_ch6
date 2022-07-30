import 'package:flutter/material.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';
import 'package:sqflite_ch6/util/dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.openDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DbHelper helper = DbHelper();
    // helper.testDb();
    return MaterialApp(
      title: 'Shopping List',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Shopping List'),
          ),
          body: ShList()),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({Key? key}) : super(key: key);

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ShoppingList>? shoppingList;

  @override
  void initState() {
    super.initState();
    showData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (shoppingList != null) ? shoppingList!.length : 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(shoppingList![index].name!),
          leading: CircleAvatar(
            child: Text(shoppingList![index].priority.toString()),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Future showData() async {
    await DbHelper.openDb();
    print('show');
    shoppingList = await DbHelper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });

    ShoppingList list = ShoppingList('Backery', 2);
    int listId = await DbHelper.insertList(list);

    ListItem item = ListItem(listId, 'Bread', 'many', '1 kg');
    int itemId = await DbHelper.insertItem(item);
    print('List Id: $listId');
    print('Item Id: $itemId');
  }
}
