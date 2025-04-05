import 'dart:ui';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isFirstPasswordVisible = false;
  bool _isSecondPasswordVisible = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email_for_signup = TextEditingController();
  final TextEditingController _password_for_signup = TextEditingController();
  final  TextEditingController _confirm_password_for_signup =TextEditingController();

  @override
  // dispose function for the controllers
void dispose(){
    _name.dispose();
    _email_for_signup.dispose();
    _password_for_signup.dispose();
    _confirm_password_for_signup.dispose();
    super.dispose();
  }
  //dispose function ends here

  Future<void> user_with_email_and_password() async{
    final UserCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _password_for_signup.text.trim(),
      password: _confirm_password_for_signup.text.trim(),
    );
  }

  // validating function for the password and the confirm password field

  void validate_password()
  {
    if(_password_for_signup.text != _confirm_password_for_signup.text)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match"),
          backgroundColor: Colors.red,duration:Duration(seconds: 2),)
        );
      }
    else
      {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords Match "),
        backgroundColor: Colors.green,duration: Duration(seconds: 2),)
      );
      }
  }
  // this validation function ends here

  // scaffold code for here
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
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email/Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _password_for_signup,
                  obscureText: !_isFirstPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isFirstPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFirstPasswordVisible = !_isFirstPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _confirm_password_for_signup,
                  obscureText: !_isSecondPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isSecondPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSecondPasswordVisible = !_isSecondPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                   await user_with_email_and_password();
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
