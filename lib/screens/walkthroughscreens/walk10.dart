import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class walk10 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk10({super.key, required this.nextPage});

  @override
  State<walk10> createState() => _Walk10State();
}

class _Walk10State extends State<walk10> {
  String? selectedOption;

  Future<void> save_Walk_through_Data(String key, String value) async {
    if (selectedOption != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print("Saved option: $value");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No item selected!"), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> saveWalkthroughData(String key, String value) async {
    if (selectedOption != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print("Saved option: $value");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No item selected!"), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Center(
              child: Text(
                "Where did you hear\n about us?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          SizedBox(height: 40),

          _buildSelectableTile("In social media ad", FontAwesomeIcons.bullhorn, Colors.blueAccent),
          SizedBox(height: 20),
          _buildSelectableTile("From a person I follow", FontAwesomeIcons.userFriends, Colors.green),
          SizedBox(height: 20),
          _buildSelectableTile("From my friend", FontAwesomeIcons.user, Colors.orange),
          SizedBox(height: 20),
          _buildSelectableTile("On TV", FontAwesomeIcons.tv, Colors.redAccent),
          SizedBox(height: 20),
          _buildSelectableTile("On the radio", FontAwesomeIcons.radio, Colors.purple),
          SizedBox(height: 20),
          _buildSelectableTile("Other", FontAwesomeIcons.questionCircle, Colors.grey),

          SizedBox(height: 35),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
              onPressed: () {
                save_Walk_through_Data("Refrence", selectedOption ?? "");

                if(selectedOption == null ){
                  print("stay");
                }
                else
                {
                  widget.nextPage();
                }
              },
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Widget _buildSelectableTile(String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        trailing: Radio<String>(
          value: title,
          groupValue: selectedOption,
          activeColor: Colors.black,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            selectedOption = title;
          });
        },
      ),
    );
  }
}
