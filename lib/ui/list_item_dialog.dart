import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_ch6/models/list_items.dart';
import 'package:sqflite_ch6/util/dbhelper.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();
    DbHelper.openDb();
    if (!isNew) {
      txtName.text = item.name!;
      txtQuantity.text = item.quantity!;
      txtNote.text = item.note!;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping item' : 'Edit shopping item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Item Name'),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(hintText: 'Note'),
            ),
            ElevatedButton(onPressed: () {
              item.name = txtName.text;
              item.quantity = txtQuantity.text;
              item.note = txtNote.text;
              DbHelper.insertItem(item);
              Navigator.pop(context);
            },
              child: Text('Save Item'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),),
          ],
        ),
      ),
    );
  }
}