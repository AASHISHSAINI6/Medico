import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
class walk6 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk6({super.key, required this.nextPage});

  @override
  State<walk6> createState() => _walk2State();
}

class _walk2State extends State<walk6> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // the space from the above
          SizedBox(height: 80,),
          // the text
          Center(child: Text("Are you currently \n following a diet ?",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
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
              leading: Icon(Icons.tag_faces_sharp,color: Colors.deepOrangeAccent,),  // Icon on the left side
              title: Text("Standard",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("I eat everything"),  // Subtitle below title
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
              leading: Icon(FontAwesomeIcons.tree,color: Colors.redAccent,size: 30,),  // Icon on the left side
              title: Text("Vegetarian",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("I can't eat meat or seafood"),  // Subtitle below title
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
              leading: Icon(FontAwesomeIcons.cow,color: CupertinoColors.systemYellow,size: 30,),  // Icon on the left side
              title: Text("Vegan",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("I can't eat animal product"),  // Subtitle below title
              // Icon on the right side
              onTap: () {
                print("Tile clicked!");
              },
            ),
          ),
          SizedBox(height: 20,),
          // last and 4th list tile
          Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),  // Border color and width
              borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading:
              Icon(FontAwesomeIcons.breadSlice, size: 20, color: Colors.brown.shade200),  // Icon on the left side
              title: Text("Gluten-Free",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),      // Main title
              subtitle: Text("Gluten strictly excluded"),  // Subtitle below title
              // Icon on the right side
              onTap: () {
                print("Tile clicked!");
              },
            ),
          ),
          // sized box
          SizedBox(height: 100,),
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
