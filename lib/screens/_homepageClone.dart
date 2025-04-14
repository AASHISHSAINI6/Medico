import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medico/screens/ChatScreen.dart';
import 'package:medico/screens/profilepage.dart';
import 'package:medico/screens/settings.dart';
import 'NotificationPage.dart';
import 'historypage.dart';
import 'loginpage.dart';

class HomePageClone extends StatefulWidget {
  const HomePageClone({super.key});

  @override
  State<HomePageClone> createState() => _HomePageCloneState();
}

class _HomePageCloneState extends State<HomePageClone> {
  final TextEditingController controller = TextEditingController();
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode(); // Add FocusNode for TextField

  Future<void> goChatscreen() async {
    String text = controller.text.trim();
    if (text.isEmpty) return;

// Dismiss keyboard and remove focus
    _focusNode.unfocus();
    FocusScope.of(context).unfocus();

// Wait to ensure keyboard is fully dismissed
    await Future.delayed(const Duration(milliseconds: 200));

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => Chatscreen(initialMessage: text),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    );

    controller.clear();
  }

  @override
  void initState() {
    super.initState();
// Ensure TextField doesn't take focus automatically
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Medico",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
// Navigate to Notifications Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Medico!\nStart a chat by typing a Symptoms...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: _focusNode, // Assign FocusNode
                      autofocus: false, // Prevent auto-focus
                      decoration: InputDecoration(
                        labelText: "Ask Medico...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        suffixIcon: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded,
                                color: Colors.white),
                            onPressed: goChatscreen,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => goChatscreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
// setState(() {
//   _previousIndex = _selectedIndex;
//   _selectedIndex = 0;
// });
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
              leading: const Icon(Icons.edit_note_sharp),
              title: const Text("New Chat"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageClone()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Historypage()));
// setState(() {
//   _previousIndex = _selectedIndex;
//   _selectedIndex = 2; // Switch to History tab
// });
              },
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
          ],
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
          onTabChange: (index) {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientForm()),
              );
            } if (index == 1){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chatscreen(initialMessage: '',)),
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
