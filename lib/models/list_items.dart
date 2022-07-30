class ListItem {
  int? id;
  int? idList;
  String? name;
  String? quantity;
  String? note;

  ListItem(this.idList, this.name, this.quantity, this.note, {this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': /*id == 0 ? null :*/ id,
      'idList': idList,
      'name': name,
      'quantity': quantity,
      'note': note,
    };
  }

  ListItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    id = map['idList'];
    id = map['name'];
    id = map['quantity'];
    id = map['note'];
  }
}
