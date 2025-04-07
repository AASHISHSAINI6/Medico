import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medico/screens/Onboarding.dart';
import 'package:medico/screens/homepage.dart';
import 'package:medico/screens/profilepage.dart';
import 'signup.dart'; // Import the signup page

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
// creating the text controller
  final TextEditingController _email_controller_login = TextEditingController();
  final TextEditingController _password_controller_login =
      TextEditingController();

  //funtion for the alert dialoug box
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Complete Your Profile"),
          content: Text("Fill in your details to get accurate results."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Later"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientForm()),
                );
              },
              child: Text("Complete Now"),
            ),
          ],
        );
      },
    );
  }

  @override

  // handling the memory leak of the controller
  void dispose() {
    _email_controller_login.dispose();
    _password_controller_login.dispose();
    super.dispose();
  }

  // here the dispose function ends
  //writing a function for the authentication of email
  Future<void> login_user_with_email_password() async {
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _email_controller_login.text.trim(),
          password: _password_controller_login.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successful!"),backgroundColor: Colors.green,duration: Duration(seconds: 2),));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WalkthroughScreen()));
      _showProfileDialog(context);

    }
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "An error Occurred"),backgroundColor: Colors.red,duration: Duration(seconds: 2),));
    }
    catch (e) {
      // Generic errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  //function of auth ends right here
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/doctor.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(CupertinoIcons.heart_fill,
                        size: 120, color: Colors.white),
                    Transform.translate(
                      offset: Offset(0, -1),
                      child: Icon(CupertinoIcons.plus,
                          size: 50, color: Colors.blue.shade300),
                    ),
                  ],
                ),
                TextField(
                  controller: _email_controller_login,
                  decoration: InputDecoration(
                    hintText: "Email/Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _password_controller_login,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    await login_user_with_email_password();
                  },
                  child: Text(
                    "LOG IN",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
