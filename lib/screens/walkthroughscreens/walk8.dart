import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

class walk8 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk8({super.key, required this.nextPage});

  @override
  State<walk8> createState() => _walk2State();
}

class _walk2State extends State<walk8> {
  int _selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Text(
            "Which meals do you \n      usually have ? ",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 70,
          ),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Row(
                children: [
                  Icon(Icons.breakfast_dining, color: Colors.black), // Icon before text
                  SizedBox(width: 10),
                  Text('Breakfast',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
              value: 1,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              controlAffinity: ListTileControlAffinity
                  .trailing, // Moves radio button to the right
            ),
          ),
          SizedBox(height: 20,),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Row(
                children: [
                  Icon(Icons.fastfood_rounded, color: Colors.redAccent), // Icon before text
                  SizedBox(width: 10),
                  Text('Snack',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
              value: 2,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              controlAffinity: ListTileControlAffinity
                  .trailing, // Moves radio button to the right
            ),
          ),
          SizedBox(height: 20,),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Row(
                children: [
                  Icon(Icons.lunch_dining, color: Colors.brown), // Icon before text
                  SizedBox(width: 10),
                  Text('Lunch',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
              value: 3,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              controlAffinity: ListTileControlAffinity
                  .trailing, // Moves radio button to the right
            ),
          ),
          SizedBox(height: 20,),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Row(
                children: [
                  Icon(Icons.dinner_dining, color: Colors.blue), // Icon before text
                  SizedBox(width: 10),
                  Text('Dinner',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ],
              ),
              value: 4,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              controlAffinity: ListTileControlAffinity
                  .trailing, // Moves radio button to the right
            ),
          ),
          SizedBox(height: 150,),
          // end of the sized box
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100),
              onPressed: () {widget.nextPage();},
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
