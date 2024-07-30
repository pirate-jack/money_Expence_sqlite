// item.dart
class Item {
  final int? itemId;
  final String itemName;
  final double itemPrice;
  final String itemDescription;
  final int createAt;
  final int userId;

  Item({
    this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.itemDescription,
    required this.userId,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'item_name': itemName,
      'item_price': itemPrice,
      'item_description': itemDescription,
      'user_id': userId,
      'createAt':createAt,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['item_id'],
      itemName: map['item_name'],
      itemPrice: map['item_price'],
      itemDescription: map['item_description'],
      userId: map['user_id'],
      createAt: map['createAt'],
    );
  }
}
