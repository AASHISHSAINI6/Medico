import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class walk2 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk2({super.key, required this.nextPage});

  @override
  State<walk2> createState() => _walk2State();
}

class _walk2State extends State<walk2> {
  String? selectedOption;

// writing a function for taking a data in the shared prefrence and save it in the local storage
  Future<void> save_walk_through_data( String key,String Value) async
  {
    if(selectedOption != null)
      {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
        await prefs.setString(key ,Value);
        print("saved option : $Value");
      }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No item selected!"),duration: Duration(seconds: 2),));
    }
  }
  // function ends here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Center(
              child: Text(
                "What Motivates You \n        The Most !",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
          SizedBox(height: 50),

          buildListTile("Feeling confident", "I want to be more confident in myself", Icons.thumb_up, Colors.deepOrangeAccent),
          SizedBox(height: 20),
          buildListTile("Being Active", "I want to feel energetic, fit and healthy", Icons.directions_run, Colors.redAccent),
          SizedBox(height: 20),
          buildListTile("Being Noticed", "I want to be appreciated and loved", Icons.person, CupertinoColors.systemYellow),
          SizedBox(height: 20),
          buildListTile("Gaining muscle", "I want to be and look stronger", FontAwesomeIcons.dumbbell, Colors.black),
          SizedBox(height: 60),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
              onPressed: () {
               save_walk_through_data("motivation", selectedOption ?? "");

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

  Widget buildListTile(String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Radio<String>(
          value: title,
          groupValue: selectedOption,
          onChanged: (String? value) {
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
