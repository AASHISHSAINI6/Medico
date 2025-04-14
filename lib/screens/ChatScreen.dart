import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:medico/screens/profilepage.dart';

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });

  String getFormattedTime() => DateFormat('h:mm a').format(date);
  String getFormattedDate() => DateFormat('MMM dd, yyyy').format(date);
}

class Chatscreen extends StatefulWidget {
  final String initialMessage;

  const Chatscreen({super.key, required this.initialMessage});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Add FocusNode for TextField

  List<Message> messages = [
    Message(
      text: "Yes Sure!",
      date: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentByMe: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add initial message directly in initState
    if (widget.initialMessage.isNotEmpty) {
      messages.add(
        Message(
          text: widget.initialMessage,
          date: DateTime.now(),
          isSentByMe: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  Future<void> _sendMessage() async {
    String userInput = controller.text.trim();
    if (userInput.isEmpty) return;

    final newMessage = Message(
      text: userInput,
      date: DateTime.now(),
      isSentByMe: true,
    );

    setState(() {
      messages.add(newMessage);
    });

    controller.clear();
    _focusNode.unfocus(); // Dismiss keyboard after sending
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Medico",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (msg) => DateTime(msg.date.year, msg.date.month, msg.date.day),
              groupHeaderBuilder: (Message message) => SizedBox(
                height: 40,
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat.yMMMd().format(message.date),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, Message message) => Align(
                alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  elevation: 8,
                  color: message.isSentByMe ? Colors.deepPurple[100] : Colors.grey[200], // Optional: Differentiate colors
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(message.text.trim()),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              focusNode: _focusNode, // Assign FocusNode
              autofocus: false, // Prevent auto-focus
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(12),
                labelText: "Ask Medico...",
                suffixIcon: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          backgroundColor: Colors.deepPurple,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.deepPurpleAccent,
          gap: 8,
          padding: const EdgeInsets.all(16),
          onTabChange: (index) {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientForm()), // Replaced PatientForm
              );
            }
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.chat, text: "Chat"),
            GButton(icon: Icons.history, text: "History"),
            GButton(icon: Icons.person, text: "Profile"),
          ],
        ),
      ),
    );
  }
}