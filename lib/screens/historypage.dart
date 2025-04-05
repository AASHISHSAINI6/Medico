import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';

class HistoryTab extends StatefulWidget {
  final List<List<ChatMessage>> sessions;

  const HistoryTab({super.key, required this.sessions});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late List<List<ChatMessage>> _localSessions;

  @override
  void initState() {
    super.initState();
    _localSessions = List.from(widget.sessions);
    print("HistoryTab initialized with ${_localSessions.length} sessions");
  }

  Map<String, List<MapEntry<int, List<ChatMessage>>>> _groupSessionsByCategory() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final last7DaysStart = today.subtract(const Duration(days: 7));

    final grouped = <String, List<MapEntry<int, List<ChatMessage>>>>{
      'Today': [],
      'Yesterday': [],
      'Last 7 Days': [],
    };

    for (var i = 0; i < _localSessions.length; i++) {
      final session = _localSessions[i];
      if (session.isEmpty) {
        print("Skipping empty session at index $i");
        continue;
      }

      final sessionDate = DateTime(
        session.first.timestamp.year,
        session.first.timestamp.month,
        session.first.timestamp.day,
      );
      if (sessionDate == today) {
        grouped['Today']!.add(MapEntry(i, session));
      } else if (sessionDate == yesterday) {
        grouped['Yesterday']!.add(MapEntry(i, session));
      } else if (sessionDate.isAfter(last7DaysStart) && sessionDate.isBefore(today)) {
        grouped['Last 7 Days']!.add(MapEntry(i, session));
      }
    }

    print("Grouped sessions: Today=${grouped['Today']!.length}, Yesterday=${grouped['Yesterday']!.length}, Last 7 Days=${grouped['Last 7 Days']!.length}");
    return grouped;
  }

  void _deleteSession(int sessionIndex) {
    if (!mounted) {
      print("Widget is not mounted, skipping setState");
      return;
    }

    setState(() {
      if (sessionIndex >= 0 && sessionIndex < _localSessions.length) {
        _localSessions.removeAt(sessionIndex);
        widget.sessions.removeAt(sessionIndex);
        print("Deleted session at index $sessionIndex, Remaining sessions: ${_localSessions.length}");
      } else {
        print("Invalid session index: $sessionIndex");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedByCategory = _groupSessionsByCategory();
    final categories = ['Today', 'Yesterday', 'Last 7 Days'];

    return _localSessions.isEmpty
        ? const Center(child: Text("No chat history yet.", style: TextStyle(fontSize: 16)))
        : ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final sessions = groupedByCategory[category]!;
        if (sessions.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...sessions.map((entry) {
              final sessionIndex = entry.key;
              final session = entry.value;
              if (session.isEmpty) {
                print("Encountered empty session at index $sessionIndex");
                return const SizedBox.shrink();
              }
              final timeAgo = _getTimeAgo(session.first.timestamp);
              return ListTile(
                title: Text(
                  timeAgo,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => _deleteSession(sessionIndex),
                ),
                onTap: () {
                  if (session.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(
                          date: DateFormat('MMM dd, yyyy').format(session.first.timestamp),
                          messages: session,
                        ),
                      ),
                    );
                  } else {
                    print("Cannot navigate to empty session at index $sessionIndex");
                  }
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else {
      return "${difference.inDays} days ago";
    }
  }
}

class ChatDetailPage extends StatelessWidget {
  final String date;
  final List<ChatMessage> messages;

  const ChatDetailPage({super.key, required this.date, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat from $date", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade200,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: messages.isEmpty
          ? const Center(child: Text("No messages in this session.", style: TextStyle(fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Align(
            alignment: message.isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isSentByUser ? Colors.white : Colors.deepPurple.shade200,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: message.isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(color: message.isSentByUser ? Colors.black : Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.getFormattedTime(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}