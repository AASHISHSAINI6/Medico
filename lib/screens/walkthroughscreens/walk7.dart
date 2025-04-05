import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

class walk7 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk7({super.key, required this.nextPage});

  @override
  State<walk7> createState() => _walk2State();
}

class _walk2State extends State<walk7> {
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
            "Select items that \n    you Don't eat ! ",
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
              title: Text('Standard'),
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
              title: Text('Vegitarian'),
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
              title: Text('Vegan'),
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
              title: Text('Gluten-Free'),
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
