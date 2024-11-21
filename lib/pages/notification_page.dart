import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0), // Flipkart blue color
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount:
            10, // Example: You can replace with your dynamic notifications
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Color(0xFF2874F0),
                  size: 30,
                ),
              ),
              title: Text(
                'Notification #${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'This is a brief description of the notification.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                // You can handle tap here, like navigating to specific details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped on Notification #${index + 1}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
