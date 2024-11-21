import 'package:flutter/material.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with dynamic item count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            subtitle: Text('Description of Item $index'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Add functionality for item details or other interactions
            },
          );
        },
      ),
    );
  }
}
