// lib/models.dart
class NotificationModel {
  final String title;
  final String time;
  bool isRead;

  NotificationModel({required this.title, required this.time, this.isRead = false});
}