import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
class walk9 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk9({super.key, required this.nextPage});

  @override
  State<walk9> createState() => _walk2State();
}

class _walk2State extends State<walk9> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // the space from the above
          SizedBox(height: 80,),
          // the text
          Center(child: Text("   How varied do you \n want your diet to be ?",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
          // this is the listtile in for the content
          SizedBox(height: 50,),
          // end of the sized box
          // first list tile
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width:3),  // Border color and width
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: Text("   Low Variety",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("    Meals frequently repeated"),  // Subtitle below title
              // Icon on the right side
              onTap: () {
                print("Tile clicked!");
              },
            ),
          ),
          // adding the sized box for space
          SizedBox(height: 20,),
          // second list tile
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: Text("   Medium Variety",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("    Meals repeated from time to time"),  // Subtitle below title
              // Icon on the right side
              onTap: () {
                print("Tile clicked!");
              },
            ),
          ),
          // adding the sized box
          SizedBox(height: 20,),
          // third list tile
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: Text("   High Variety",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("    Meals rarely repeated"),  // Subtitle below title
              // Icon on the right side
              onTap: () {
                print("Tile clicked!");
              },
            ),
          ),

          // sized box
          SizedBox(height: 180,),
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
