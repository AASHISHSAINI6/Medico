import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class walk6 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk6({super.key, required this.nextPage});

  @override
  State<walk6> createState() => _walk2State();
}

class _walk2State extends State<walk6> {
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
                "Are you currently \n following a diet ?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
          SizedBox(height: 50),

          // Standard ListTile
          _buildSelectableTile("Standard", "I eat everything",
              Icons.tag_faces_sharp, Colors.deepOrangeAccent),

          SizedBox(height: 20),

          // Vegetarian ListTile
          _buildSelectableTile("Vegetarian", "I can't eat meat or seafood",
              FontAwesomeIcons.tree, Colors.redAccent),

          SizedBox(height: 20),

          // Vegan ListTile
          _buildSelectableTile("Vegan", "I can't eat animal product",
              FontAwesomeIcons.cow, CupertinoColors.systemYellow),

          SizedBox(height: 20),

          // Gluten-Free ListTile
          _buildSelectableTile("Gluten-Free", "Gluten strictly excluded",
              FontAwesomeIcons.breadSlice, Colors.brown.shade200),

          SizedBox(height: 100),

          ElevatedButton(
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
              onPressed: ()  {
                save_walk_through_data("diet", selectedOption ?? "");

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

  Widget _buildSelectableTile(String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
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
          print("Selected via tap: $title");
        },
      ),
    );
  }
}
