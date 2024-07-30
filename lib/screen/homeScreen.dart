import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/DbHelper/dbHelper.dart';
import 'package:money/models/itemModel.dart';
import 'package:money/screen/expenceAdd.dart';
import 'package:money/screen/login.dart';
import 'package:money/sharePrefrence/sharePrefrence.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final DbHelper _dbHelper = DbHelper();
  List<Item> _items = [];
  late int _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndItems();
  }

  Future<void> _loadUserIdAndItems() async {
    _userId = (await PrefrenceManager.getUserId())!;
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _dbHelper.getItemsByUserId(_userId);
    setState(() {
      _items = items;
    });
  }

  void _toggleStatus() {
    PrefrenceManager.statusChange(false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _toggleStatus();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(Item item) async {
    final nameController = TextEditingController(text: item.itemName);
    final priceController =
        TextEditingController(text: item.itemPrice.toString());
    final descriptionController =
        TextEditingController(text: item.itemDescription);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Item Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedItem = Item(
                  itemId: item.itemId,
                  itemName: nameController.text,
                  itemPrice:
                      double.tryParse(priceController.text) ?? item.itemPrice,
                  itemDescription: descriptionController.text,
                  userId: item.userId,
                  createAt: DateTime.now().millisecondsSinceEpoch,
                );
                await _dbHelper.updateItem(updatedItem);
                Navigator.pop(context);

                // Show SnackBar for successful update
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item updated successfully!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _fetchItems(); // Refresh list
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteItem(item.itemId!);
                Navigator.pop(context);

                // Show SnackBar for successful deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item deleted successfully!'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _fetchItems(); // Refresh list
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpensePage()),
          );

          if (result == true) {
            _fetchItems(); // Refresh items after adding
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('HomeScreen'),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.green),
              title: Text(item.itemName),
              subtitle: Text(
                  '₹ ${item.itemPrice}\n${item.itemDescription}\n${formatMilliseconds(item.createAt)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditItemDialog(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(item),
                  ),
                ],
              ),
              onTap: () => _showEditItemDialog(item),
            ),
          );
        },
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    // Convert milliseconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    String formattedDate = DateFormat('dd/MM/yy hh:mm a').format(dateTime);

    return formattedDate;
  }
}
