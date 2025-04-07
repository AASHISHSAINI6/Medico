import 'package:firebase_auth/firebase_auth.dart'; // UPDATED CODE
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medico/screens/Onboarding.dart';
import 'package:medico/screens/homepage.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to next screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())); // UPDATED CODE
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(seconds: 2),
        opacity: _opacity,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade100, Colors.blue.shade700],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(CupertinoIcons.heart_fill, size: 120, color: Colors.white),
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Icon(CupertinoIcons.plus, size: 50, color: Colors.blue.shade300),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // App Name
                  Text(
                    "Medico",
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 5, color: Colors.black.withOpacity(0.3), offset: Offset(2, 2))
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Tagline
                  Text(
                    "\"Where compassion\nand healthcare meet\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Loading Indicator
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
