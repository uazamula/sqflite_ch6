class ShoppingList {
  int? id;
  String? name;
  int? priority;

  ShoppingList( this.name, this.priority, {this.id});

  Map<String, dynamic> toMap() {
    return {
      //TODO maybe you need to remove ternary operator
      'id': /*id ?? */id,
      'name': name,
      'priority': priority,
    };
  }
}
