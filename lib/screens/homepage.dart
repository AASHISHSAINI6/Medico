import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medico/Services/infermedica_service.dart';
import 'package:medico/screens/loginpage.dart';
import 'package:medico/screens/profilepage.dart';
import 'package:medico/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'NotificationPage.dart';
import 'historypage.dart';
import 'models.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'profilepage.dart';



class ChatMessage {
  final String text;
  final bool isSentByUser;
  final List<String> imagePaths;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByUser,
    this.imagePaths = const [],
    required this.timestamp,
  });

  String getFormattedTime() => DateFormat('h:mm a').format(timestamp);
  String getFormattedDate() => DateFormat('MMM dd, yyyy').format(timestamp);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final List<ChatMessage> _messages = []; // Current chat session (displayed)
  final List<ChatMessage> _currentChatHistory = []; // Current session history
  final List<List<ChatMessage>> _previousChatSessions = []; // List of previous chat sessions
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _selectedImagePaths = [];
  final List<NotificationModel> _notifications = [];
  int _selectedIndex = 0; // Start on Home tab
  int _previousIndex = 0; // Track the previous index for directionality

  @override
  void initState() {
    super.initState();
    // Add a sample notification for testing
    _notifications.add(NotificationModel(
      title: "Test Notification",
      time: DateFormat('h:mm a').format(DateTime.now()),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _fetchFromInfermedica(String userInput) async {
    const String apiUrl = "https://api.infermedica.com/v3/parse";
    const String appId = "YOUR_APP_ID"; // Replace with your actual APP-ID
    const String appKey = "YOUR_APP_KEY"; // Replace with your actual APP-KEY

    final headers = {
      'App-Id': appId,
      'App-Key': appKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "text": userInput,
      "include_tokens": true,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final mentions = data['mentions'] as List<dynamic>;
        if (mentions.isEmpty) {
          return "Sorry, I couldn't understand any symptoms. Please try again.";
        }

        final symptoms = mentions.map((m) => m['name']).join(', ');
        return "I understood the following symptoms: $symptoms.\nWould you like to proceed with diagnosis?";
      } else {
        return "API Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Something went wrong: $e";
    }
  }

  List<Map<String, dynamic>> _evidence = [];
  bool _awaitingDiagnosisConfirmation = false;

  Future<void> _sendMessage() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

  //older code for home to chat page
  //   setState(() {
  //     _previousIndex = _selectedIndex;
  //     _selectedIndex = 1; // Switch to Chat tab when sending a message
  //     final _messages = ChatMessage(
  //       text: _controller.text.isNotEmpty ? _controller.text : "Images uploaded",
  //       isSentByUser: true,
  //       imagePaths: _selectedImagePaths,
  //       timestamp: DateTime.now(),
  //     );
  //     _currentChatHistory.add(_messages);
  //     _notifications.add(NotificationModel(
  //       title: "New message sent",
  //       time: DateFormat('h:mm a').format(DateTime.now()),
  //     ));
  //     print("Message sent: ${_messages.text}, Total messages in current session: ${_currentChatHistory.length}");
  //   });
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  //
    final newMessage = ChatMessage(
      text: userInput,
      isSentByUser: true,
      timestamp: DateTime.now(),
    );

    // Add the user's message
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = 1;

     //_messages.add(newMessage);
      _currentChatHistory.add(newMessage);
      _notifications.add(NotificationModel(
        title: "New message sent",
        time: DateFormat('h:mm a').format(DateTime.now()),
      ));
    });

// Scroll to bottom
    await Future.delayed(Duration(milliseconds: 100)); // Ensure UI is built before scrolling
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );



    setState(() {
      _messages.add(ChatMessage(text: userInput, isSentByUser: true, timestamp: DateTime.now()));
    });

    _controller.clear();

    // Check if user says "yes" and we're awaiting confirmation
    if (_awaitingDiagnosisConfirmation &&
        (userInput.toLowerCase().contains("yes") ||
            userInput.toLowerCase().contains("ok"))) {

      // Proceed to diagnosis
      final diagnosisResponse = await http.post(
        Uri.parse("https://api.infermedica.com/v3/diagnosis"),
        headers: {
          'Content-Type': 'application/json',
          'App-Id': 'YOUR_APP_ID',
          'App-Key': 'YOUR_APP_KEY',
        },
        body: jsonEncode({
          "sex": "male", // or ask the user
          "age": 25,     // or get from user profile
          "evidence": _evidence
        }),
      );

      final diagnosisData = jsonDecode(diagnosisResponse.body);
      final conditions = diagnosisData["conditions"];

      if (conditions.isNotEmpty) {
        String conditionText = "Based on your symptoms, you might have:\n";
        for (var condition in conditions.take(3)) {
          conditionText +=
          "- ${condition["name"]} (${(condition["probability"] * 100).toStringAsFixed(1)}%)\n";
        }
        setState(() {
          _messages.add(ChatMessage(text: conditionText, isSentByUser: false, timestamp: DateTime.now()));
          _awaitingDiagnosisConfirmation = false; // Reset
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(text: "Sorry, I couldn't identify any conditions.", isSentByUser: false, timestamp: DateTime.now()));
          _awaitingDiagnosisConfirmation = false;
        });
      }

      return;
    }

    // Normal flow — parse input for symptoms
    final response = await http.post(
      Uri.parse("https://api.infermedica.com/v3/parse"),
      headers: {
        'Content-Type': 'application/json',
        'App-Id': 'YOUR_APP_ID',
        'App-Key': 'YOUR_APP_KEY',
      },
      body: jsonEncode({
        "text": userInput,
        "include_tokens": true
      }),
    );

    final data = jsonDecode(response.body);
    final mentions = data["mentions"];

    if (mentions.isEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: "Sorry, I couldn't identify any symptoms. Please try again.", isSentByUser: false,timestamp:DateTime.now()));
      });
      return;
    }

    _evidence = mentions.map<Map<String, dynamic>>((mention) {
      return {
        "id": mention["id"],
        "choice_id": "present"
      };
    }).toList();

    setState(() {
      _messages.add(ChatMessage(
        text: "I understood the following symptoms: ${mentions.map((m) => m["name"]).join(", ")}.\nWould you like to proceed with diagnosis?",
        isSentByUser: false,timestamp: DateTime.now()
      ));
      _awaitingDiagnosisConfirmation = true;
    });
  }


  void _pickImages() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
    if (result != null) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = 1; // Switch to Chat tab when images are picked
        _selectedImagePaths = result.files.map((file) => file.path!).toList();
        print("Images picked: ${_selectedImagePaths.length}");
      });
    }
  }

  void _startNewChat() {
    setState(() {
      if (_currentChatHistory.isNotEmpty) {
        _previousChatSessions.add(List.from(_currentChatHistory));
        print("Added session to history: ${_currentChatHistory.length} messages, Total sessions: ${_previousChatSessions.length}");
      } else {
        print("No messages to add to history");
      }
      _previousIndex = _selectedIndex;
      _selectedIndex = 0; // Switch back to Home tab
      _currentChatHistory.clear();
      _messages.clear();

      // _selectedImagePaths.clear();

      _controller.clear();
      _notifications.add(NotificationModel(
        title: "New chat started",
        time: DateFormat('h:mm a').format(DateTime.now()),
      ));
    });
  }

  void _onTabChange(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      print("Switched to tab: $_selectedIndex");
    });
  }

  int get _unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to Medico!\nStart a chat by typing a Symptoms.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ask Medico...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickImages,
                    ),
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded,color: Colors.white,),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(), // Switch to Chat tab on submission
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
                alignment: message.isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: message.isSentByUser ? Colors.white : Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: message.isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (message.imagePaths.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: message.imagePaths.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.file(File(message.imagePaths[i]), width: 80, height: 80),
                            ),
                          ),
                        ),
                      Text(
                        message.text,
                        style: TextStyle(color: message.isSentByUser ? Colors.black : Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(message.getFormattedTime(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ask Medico...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickImages,
                    ),
                    suffixIcon: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.deepPurple,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded,color: Colors.white,),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return HistoryTab(sessions: _previousChatSessions);
  }

  Widget _buildNotificationsTab() {
    print("Building NotificationsTab with ${_notifications.length} notifications");
    return NotificationsTab(notifications: _notifications);
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    final isForward = _selectedIndex > _previousIndex;
    final beginOffset = isForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0); // Right or Left

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Medico", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.deepPurple,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _startNewChat,
            tooltip: "New Chat",
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 49,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/doctor.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User Name",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _previousIndex = _selectedIndex;
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _previousIndex = _selectedIndex;
                  _selectedIndex = 2; // Switch to History tab
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: _buildTransition,
        child: _selectedIndex == 0
            ? Container(
          key: const ValueKey('HomeTab'),
          child: _buildHomeTab(),
        )
            : _selectedIndex == 1
            ? Container(
          key: const ValueKey('ChatTab'),
          child: _buildChatTab(),
        )
            : _selectedIndex == 2
            ? Container(
          key: const ValueKey('HistoryTab'),
          child: _buildHistoryTab(),
        )
            : Container(
          key: const ValueKey('NotificationsTab'),
          child: _buildNotificationsTab(),
        ),
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
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
          tabs: [
            const GButton(icon: Icons.home, text: "Home"),
            const GButton(icon: Icons.chat, text: "Chat"),
            const GButton(icon: Icons.history, text: "History"),
            GButton(
              icon: Icons.notifications,
              text: "Notifications",
              leading: Stack(
                children: [
                  const Icon(Icons.notifications, color: Colors.white),
                  if (_unreadNotificationCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$_unreadNotificationCount",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}