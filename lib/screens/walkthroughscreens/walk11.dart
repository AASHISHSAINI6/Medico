import 'package:flutter/material.dart';
import 'package:medico/screens/loginpage.dart';
class walk11 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk11({super.key, required this.nextPage});

  @override
  State<walk11> createState() => _walk11State();
}

class _walk11State extends State<walk11> {
  int selectedAge = 18; // Default age
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100,),

          Text("How old are you?", style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
          SizedBox(height: 150),
          Container(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              physics: FixedExtentScrollPhysics(),
              perspective: 0.002,
              diameterRatio: 2,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedAge = index + 1;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: index + 1 == selectedAge ? Colors.blue : Colors.grey,
                    ),
                  );
                },
                childCount: 100, // Age limit (1-100)
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Selected Age: $selectedAge", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 150,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100),
              onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))

        ],
      ),
    );
  }
}
