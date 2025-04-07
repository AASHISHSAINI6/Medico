import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class walk7 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk7({super.key, required this.nextPage});

  @override
  State<walk7> createState() => _Walk7State();
}

class _Walk7State extends State<walk7> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Center(
            child: Text(
              "Select items that \n    you Don't eat!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),

          _buildSelectableTile("Standard",),
          SizedBox(height: 20),
          _buildSelectableTile("Vegetarian",),
          SizedBox(height: 20),
          _buildSelectableTile("Vegan", ),
          SizedBox(height: 20),
          _buildSelectableTile("Gluten-Free",),
          SizedBox(height: 100),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
            onPressed: (){
              save_Walk_through_Data("don't_eat", selectedOption ?? "");

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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableTile(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
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
          print("Selected via tap: $title");
        },
      ),
    );
  }
}
