import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_ch6/models/shopping_list.dart';
import 'package:sqflite_ch6/util/dbhelper.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = list.name!;
      txtPriority.text = list.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Shopping List Name'),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(hintText: 'Shopping List Priority (1-3)'),
            ),
            ElevatedButton(
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                DbHelper.insertList(list);
                Navigator.pop(context,true);
              },
              child: Text('Save Shopping List'),
            )
          ],
        ),
      ),
    );
  }
}
