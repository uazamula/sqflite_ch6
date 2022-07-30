class ShoppingList {
  int? id;
  String? name;
  int? priority;

  ShoppingList( this.name, this.priority, {this.id});

  Map<String, dynamic> toMap() {
    return {
      //TODO maybe you need to remove ternary operator
      'id': (id == 0) ? null : id,
      'name': name,
      'priority': priority,
    };
  }
}
