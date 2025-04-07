import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController _confirm_password_for_signup =TextEditingController();
  final FocusNode _name_focus_mode = FocusNode();
  final FocusNode _email_focus_mode = FocusNode();
  final FocusNode _password_focus_mode = FocusNode();
  final FocusNode _confirm_password_focus_mode =FocusNode();

  @override

  // void initState() {
  //   super.initState();
  //
  //   // Add listeners for all fields
  //   _name_focus_mode.addListener(() => validateField(_name, _name_focus_mode, "Name"));
  //   _email_focus_mode.addListener(() => validateField(_email_for_signup, _email_focus_mode, "Email"));
  //   _password_focus_mode.addListener(() => validateField(_password_for_signup, _password_focus_mode, "Password"));
  //   _confirm_password_focus_mode.addListener(() => validateField(_confirm_password_for_signup, _confirm_password_focus_mode, "Password"));
  // }
  //
  // /// Validates the field and prevents focus change if empty.
  // void validateField(TextEditingController controller, FocusNode focusNode, String fieldName) {
  //   if (!focusNode.hasFocus && controller.text.trim().isEmpty) {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("$fieldName cannot be empty"),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //
  //     // Prevent focus from moving forward
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       FocusScope.of(context).requestFocus(focusNode);
  //     });
  //   }
  // }

  // dispose function for the controllers
void dispose(){
    _name.dispose();
    _email_for_signup.dispose();
    _password_for_signup.dispose();
    _confirm_password_for_signup.dispose();
    _name_focus_mode.dispose();
    _email_focus_mode.dispose();
    _password_focus_mode.dispose();
    _confirm_password_focus_mode.dispose();
    super.dispose();
  }
  //dispose function ends here


  Future<void> user_with_email_and_password() async{
    try{
       final user_credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email_for_signup.text.trim(),
        password: _password_for_signup.text.trim(),
      );

       User? user = user_credential.user;
       if(user != null && !user.emailVerified)
         {
           await user.sendEmailVerification();
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification email sent!"),duration: Duration(seconds: 3),));
         }
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful! Please verify your email"),duration: Duration(seconds: 3),));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful!"),backgroundColor: Colors.green,duration: Duration(seconds: 2),));
      try {
final pref = await SharedPreferences.getInstance();

String uid = user!.uid;
Map<String,dynamic> age ={};
await FirebaseFirestore.instance.collection("Users").doc(uid).set({});
print("created a empty document for the user with the uid $uid");

// Now you can print the document ID
} catch (e) {
print(e);
}
// function ends

    }

    on FirebaseAuthException catch(e){
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

  // validating function for the password and the confirm password field

  // void validate_password()
  // {
  //   if(_password_for_signup.text != _confirm_password_for_signup.text)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Passwords do not match"),
  //         backgroundColor: Colors.red,duration:Duration(seconds: 2),)
  //       );
  //     }
  //   else
  //     {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Passwords Match "),
  //       backgroundColor: Colors.green,duration: Duration(seconds: 2),)
  //     );
  //     }
  // }


// function to check the password match
  bool is_password_matching(String password,String confrim_password)
  {
    return password == confrim_password;
  }
  // this validation function ends here

  // scaffold code for here
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    controller : _name,
                    focusNode: _name_focus_mode,
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')), //restricting the user from entering the special characters
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _email_for_signup,
                    focusNode: _email_focus_mode,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                    focusNode: _password_focus_mode,
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
                    focusNode: _confirm_password_focus_mode,
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
                      if(! is_password_matching(_password_for_signup.text.trim(), _confirm_password_for_signup.text.trim())){
                        ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Passwords do not match"),
                                    backgroundColor: Colors.red,duration:Duration(seconds: 2),)
                                  );
                        return;

                      }
                      else
                        {

                          await user_with_email_and_password();
                        }
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
      ),
    );
  }
}



