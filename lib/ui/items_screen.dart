import 'package:flutter/material.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';
import 'package:sqflite_ch6/ui/list_item_dialog.dart';
import 'package:sqflite_ch6/util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  ShoppingList? shoppingList;
  List<ListItem>? items;

  // _ItemsScreenState(this.shoppingList);

  @override
  void initState() {
    super.initState();
    shoppingList = widget.shoppingList;
    print('================= initState');
    print(
        '================= shoppingList name ${shoppingList!.toMap()['name']}');
    showData(shoppingList!.toMap()['id']);
  }

  @override
  Widget build(BuildContext context) {
    shoppingList = widget.shoppingList;
    ListItemDialog dialog = new ListItemDialog();

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList!.name!),
      ),
      body: ListView.builder(
          itemCount: (items != null) ? items!.length : 0,
          itemBuilder: ((context, index) {
            return Dismissible(
              key: Key(items![index].name!),//poh jakyj kliuch, holovne, schob rizni dla riznych items buly
              onDismissed: (direction){
                String strName = items![index].name!;
                DbHelper.deleteItem(items![index]);
                setState(() {
                  items!.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$strName deleted'),
                  ),
                );
              },
              child: ListTile(
                title: Text(items![index].name!),
                subtitle: Text('Quantity: ${items![index].quantity} - Note: '
                    '${items![index].note}'),
                onTap: () {},
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) =>
                            dialog.buildAlert(context, items![index], false));
                    setState(() {
                      items = items ;
                    });
                  },
                ),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) => dialog.buildAlert(
                  context, ListItem(shoppingList!.id, '', '', ''), true));
          setState(() {
            showData(shoppingList!.id!) ;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData(int idList) async {
    print(idList);
    items = await DbHelper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
