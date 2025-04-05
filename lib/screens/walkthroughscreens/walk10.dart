import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

class walk10 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk10({super.key, required this.nextPage});

  @override
  State<walk10> createState() => _walk2State();
}

class _walk2State extends State<walk10> {
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
            "Where did you hear \n        about us? ",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Text('In social media ad',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
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
              title: Text('From a person I follow',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
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
              title: Text('From my friend',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
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
              title: Text('On TV',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
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
          SizedBox(height: 20,),
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: RadioListTile<int>(
              title: Text('On the radio',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
              value: 5,
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
              title: Text('Other',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
              value: 6,
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
          SizedBox(height: 35,),
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
