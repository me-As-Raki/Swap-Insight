import 'package:flutter/material.dart';

class SwapRequestsPage extends StatelessWidget {
  const SwapRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap Requests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 5, // Example request count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Swap Request $index'),
            subtitle: Text('Details of Request $index'),
            trailing: const Icon(Icons.swap_horiz),
            onTap: () {
              // Handle request view or interaction
            },
          );
        },
      ),
    );
  }
}
