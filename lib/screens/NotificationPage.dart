import 'package:flutter/material.dart';
import 'package:medico/screens/_homepageClone.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'New Diagnosis Available',
        'message': 'Your health report is ready to view.',
        'time': '2 hrs ago',
        'icon': 'health_and_safety',
      },
      {
        'title': 'Reminder',
        'message': 'Don’t forget to check your symptoms today!',
        'time': '5 hrs ago',
        'icon': 'access_alarm',
      },
      {
        'title': 'Appointment Update',
        'message': 'Your doctor’s appointment is scheduled for tomorrow.',
        'time': '1 day ago',
        'icon': 'event',
      },
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Text("Notifications", style: TextStyle(color: Colors.white)),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageClone()));
              },
            ),
          )),
         body: notifications.isEmpty
          ? const Center(
        child: Text('No notifications yet!'),
          )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  _getIconData(notification['icon'] ?? 'notifications'),
                  color: Colors.blue,
                ),
              ),
              title: Text(notification['title'] ?? ''),
              subtitle: Text(notification['message'] ?? ''),
              trailing: Text(
                notification['time'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'access_alarm':
        return Icons.access_alarm;
      case 'event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }
}
