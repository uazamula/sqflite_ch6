import 'package:flutter/material.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';
import 'package:sqflite_ch6/ui/items_screen.dart';
import 'package:sqflite_ch6/ui/shopping_list_dialog.dart';
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
      home: ShList(),
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
  List<ListItem>? items;
  ShoppingListDialog? dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
    showData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList!.length : 0,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(shoppingList![index].name!),
            onDismissed: (direction) {
              String strName = shoppingList![index].name!;
              DbHelper.deleteList(shoppingList![index]);
              setState(() {
                shoppingList!.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$strName deleted'),
                ),
              );
            },
            child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemsScreen(shoppingList: shoppingList![index]),
                        ),
                      );
                      setState(() {
                        shoppingList=shoppingList;
                      });
                    },
                    title: Text(shoppingList![index].name!),
                    leading: CircleAvatar(
                      child: Text(shoppingList![index].priority.toString()),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => dialog!.buildDialog(
                                context, shoppingList![index], false));
                        setState(() {
                          shoppingList =shoppingList;
                        });
                      },
                    ),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // shoppingListIsAdded =
          await showDialog(
              context: context,
              builder: (context) =>
                  dialog!.buildDialog(context, ShoppingList('', 0), true));
          setState(() {
            // shoppingListIsAdded = shoppingListIsAdded;
            showData();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData() async {
    await DbHelper.openDb();
    print('show');
    shoppingList = await DbHelper.getLists();
    print('===Full list ===${shoppingList!.map((e) => e.id).toList()}');
    setState(() {
      shoppingList = shoppingList;
    });

    // ShoppingList list = ShoppingList('Backery', 2);
    // int listId = await DbHelper.insertList(list);
    //
    // ListItem item = ListItem(listId, 'Bread', 'many', '1 kg');
    // int itemId = await DbHelper.insertItem(item);
    // print('List Id: $listId');
    // print('Item Id: $itemId');
  }
}
