import 'package:flutter/material.dart';
import 'package:money/DbHelper/dbHelper.dart';
import 'package:money/models/itemModel.dart';
import 'package:money/sharePrefrence/sharePrefrence.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();
  late int _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    _userId = (await PrefrenceManager.getUserId())!;
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    final item = Item(
      itemName: _nameController.text,
      itemPrice: double.tryParse(_priceController.text) ?? 0.0,
      itemDescription: _descriptionController.text,
      userId: _userId,
      createAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      await _dbHelper.insertItem(item);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item added successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showErrorDialog('Failed to add item');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 200, child: Image.asset('assets/icons/taskadd.png',color: Colors.green,)),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                    labelText: 'Item Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Item Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Add Item',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
