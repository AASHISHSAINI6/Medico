// chat_storage.dart
import 'chatMessage.dart';

class ChatStorage {
  static List<List<ChatMessage>> sessions = [];

  static void addSession(String message) {
    // Start a new session with user message and mock bot reply
    sessions.add([
      ChatMessage(
        text: message,
        date: DateTime.now(),
        isSentByMe: true,
      ),
      ChatMessage(
        text: "Sample response for: $message",
        date: DateTime.now(),
        isSentByMe: false,
      ),
    ]);
  }

  static void addMessageToSession(int sessionIndex, String message) {
    // Add to existing session
    if (sessionIndex >= 0 && sessionIndex < sessions.length) {
      sessions[sessionIndex].add(ChatMessage(
        text: message,
        date: DateTime.now(),
        isSentByMe: true,
      ));
      sessions[sessionIndex].add(ChatMessage(
        text: "Sample response for: $message",
        date: DateTime.now(),
        isSentByMe: false,
      ));
    }
  }
}