// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final List<String> items = List<String>.generate(10, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELLO"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(items[index]),
            direction: DismissDirection.endToStart, // Allow swipe left only
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              // Show confirmation dialog
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Delete Confirmation"),
                    content: Text(
                        "Are you sure you want to delete ${items[index]}?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(false), // Cancel
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(true), // Confirm
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              // Remove the item from your data source
              setState(() {
                items.removeAt(index);
              });

              // Show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Text(items[index]),
            ),
          );
        },
      ),
    );
  }
}
