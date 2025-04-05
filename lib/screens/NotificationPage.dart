import 'package:flutter/material.dart';
import 'models.dart'; // Ensure this import is present

class NotificationsTab extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationsTab({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: notifications.isEmpty
              ? const Center(
            child: Text(
              "No notifications yet.",
              style: TextStyle(fontSize: 16),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.title ?? 'No Title'), // Handle null title
                subtitle: Text(notification.time ?? 'No Time'), // Handle null time
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Mark as read or handle tap
                  print("Tapped notification at index $index: ${notification.title}");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}