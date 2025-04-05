import 'package:flutter/material.dart';
import 'package:medico/screens/walkthroughscreens/walk2.dart';
import 'package:medico/screens/walkthrough.dart';

class walk1 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk1({super.key, required this.nextPage});
  @override
  State<walk1> createState() => _walk1State();
}

class _walk1State extends State<walk1> {
  String selectedGender = "";

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              // this is the space between the heading and pictures
              Text(
                "Tell Us About Yourself!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => selectGender("Male"),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedGender == "Male"
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Image.asset("assets/images/male.jpg",
                          height: 140, width: 140),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => selectGender("Female"),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedGender == "Female"
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Image.asset("assets/images/female.jpg",
                          height: 140, width: 140),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Male",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text("Female",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              SizedBox(height: 210),
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
        ),
      ),
    );
  }
}
