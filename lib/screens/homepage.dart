import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medico/screens/loginpage.dart';
import 'package:medico/screens/profilepage.dart';
import 'package:medico/screens/settings.dart';
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

  Future<String> _fetchHealthResponse(String symptom) async {
    try {
      final response = await http.get(Uri.parse('https://disease.sh/v3/diseases'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        var disease = data.firstWhere(
              (d) => (d['symptoms'] as List).any((s) => s.toString().toLowerCase() == symptom.toLowerCase()),
          orElse: () => null,
        );
        if (disease != null) {
          return "Possible condition: ${disease['disease']}. Rest and consult a doctor.";
        }
        return "No condition found for '$symptom'. Rest and consult a doctor.";
      }
      return "Error fetching data.";
    } catch (e) {
      return "Error: $e";
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty && _selectedImagePaths.isEmpty) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = 1; // Switch to Chat tab when sending a message
      final message = ChatMessage(
        text: _controller.text.isNotEmpty ? _controller.text : "Images uploaded",
        isSentByUser: true,
        imagePaths: _selectedImagePaths,
        timestamp: DateTime.now(),
      );
      _messages.add(message);
      _currentChatHistory.add(message);
      _notifications.add(NotificationModel(
        title: "New message sent",
        time: DateFormat('h:mm a').format(DateTime.now()),
      ));
      print("Message sent: ${message.text}, Total messages in current session: ${_currentChatHistory.length}");
    });

    String aiResponse = _selectedImagePaths.isNotEmpty
        ? "I see your images. Any symptoms?"
        : await _fetchHealthResponse(_controller.text);

    setState(() {
      final response = ChatMessage(
        text: aiResponse,
        isSentByUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(response);
      _currentChatHistory.add(response);
      _controller.clear();
      _selectedImagePaths = [];
      print("AI response added: ${response.text}, Total messages in current session: ${_currentChatHistory.length}");
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
      _selectedImagePaths.clear();
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
            "Welcome to Medico!\nStart a chat by typing a message.",
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
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