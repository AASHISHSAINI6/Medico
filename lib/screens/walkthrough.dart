import 'package:flutter/material.dart';
import 'package:medico/screens/walkthroughscreens/walk1.dart';
import 'package:medico/screens/walkthroughscreens/walk2.dart';
import 'package:medico/screens/walkthroughscreens/walk3.dart';
import 'package:medico/screens/walkthroughscreens/walk4.dart';
import 'package:medico/screens/walkthroughscreens/walk5.dart';
import 'package:medico/screens/walkthroughscreens/walk6.dart';
import 'package:medico/screens/walkthroughscreens/walk7.dart';
import 'package:medico/screens/walkthroughscreens/walk8.dart';
import 'package:medico/screens/walkthroughscreens/walk9.dart';
import 'package:medico/screens/walkthroughscreens/walk10.dart';
import 'package:medico/screens/walkthroughscreens/walk11.dart';

class walkscreen extends StatefulWidget {
  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<walkscreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 11; // Total number of pages

  void nextPage() {
    if (_currentPage < _totalPages - 1) { // Ensure it doesn't go beyond last page
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPages, // Progress value
              backgroundColor: Colors.grey[300],
              color: Colors.blue, // Change color as needed
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                walk1(nextPage: nextPage),
                walk2(nextPage: nextPage),
                walk3(nextPage: nextPage),
                walk4(nextPage: nextPage),
                walk5(nextPage: nextPage),
                walk6(nextPage: nextPage),
                walk7(nextPage: nextPage),
                walk8(nextPage: nextPage),
                walk9(nextPage: nextPage),
                walk10(nextPage: nextPage),
                walk11(nextPage: nextPage)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
