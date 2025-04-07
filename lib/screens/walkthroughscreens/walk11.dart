import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medico/screens/Onboarding.dart';
import 'package:medico/screens/homepage.dart';
import 'package:medico/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
class walk11 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk11({super.key, required this.nextPage});

  @override
  State<walk11> createState() => _walk11State();
}

class _walk11State extends State<walk11> {
  int selectedAge = 18; // Default age

  Future<void> save_walk_through_data( String key,String Value) async
  {
    if(selectedAge >= 15)
    {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      await prefs.setString(key ,Value);
      print("saved option : $Value");
    }
  }
// function to retrive all the data stored in the shared prefrence
  Future<Map<String, dynamic>> get_all_shared_prefs_data() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    Map<String, dynamic> allPrefs = {};

    for (String key in keys) {
      var value = prefs.get(key);
      allPrefs[key] = value;
    }
      print(allPrefs);
    print("all data is cleared");
    return allPrefs;
  }

  //function ends here


// function to clear the all the data from the shared prefrence

Future<void> clear_all_data_from_shared_prefrence() async
{
      final clear_shared = await SharedPreferences.getInstance();
      await clear_shared.clear();
}
  // function ends here
  // function to add the shred pref data to the firebase console on firebase_store
  Future<void> add_data_to_firebase_store() async {
    try {
      final pref = await SharedPreferences.getInstance();

      String uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String,dynamic> age ={
        "Age" :pref.get("Age"),
        "Motivation" :pref.get("motivation"),
        "Gender" :pref.get("gender"),
        "Height" :pref.get("height"),
        "Height_unit" :pref.get("height_unit"),
        "Weight" :pref.get("weight"),
        "Weight_unit" :pref.get("weight_unit"),
        "Goal_weight" :pref.get("goal_weight"),
        "Goal_weight_unit" :pref.get("goal_weight_unit"),
        "diet_prefrence" :pref.get("diet"),
        "Don't_eat" :pref.get("don't_eat"),
        "meals" :pref.get("meal_preference"),
        "_variety" :pref.get("Variety"),
        "refrence" :pref.get("Refrence"),
        "Data_uploaded_at" : FieldValue.serverTimestamp(),



      };
      // Add the document and store the reference
      await FirebaseFirestore.instance.collection("Users").doc(uid).set(age);
      print("data added at uid $uid");
      // Now you can print the document ID
    } catch (e) {
      print(e);
    }
  }

  // this function ends here
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
              onPressed: ()async {
                if (selectedAge < 15) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Age must be above 15"), duration: Duration(seconds: 2)),
                  );
                } else {
                  await save_walk_through_data("Age", selectedAge.toString());
                  await add_data_to_firebase_store();
                  await clear_all_data_from_shared_prefrence();
                  await get_all_shared_prefs_data();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              // {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))

        ],
      ),
    );
  }
}