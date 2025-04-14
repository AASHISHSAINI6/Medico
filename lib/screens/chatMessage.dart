// chat_message.dart
import 'package:intl/intl.dart';

class ChatMessage {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  ChatMessage({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });

  String getFormattedTime() => DateFormat('h:mm a').format(date);
  String getFormattedDate() => DateFormat('MMM dd, yyyy').format(date);
}