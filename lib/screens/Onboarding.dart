import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:medico/screens/loginpage.dart';
import 'package:medico/screens/walkthrough.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import  "package:medico/screens/introductionscreens/introscreen1.dart";
import  "package:medico/screens/introductionscreens/introscreen2.dart";
import  "package:medico/screens/introductionscreens/introscreen3.dart";

class WalkthroughScreen extends StatefulWidget {
  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  PageController _controller = PageController();

  // keeping track that we are on the last page or not
  bool onlastpage =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index){
             setState(() {
               onlastpage= (index==2);
             });
            },
            children: [
              Intropage1(),
              Intropage2(),
              Intropage3(),
            ],
          ),
          // here is the dot indicator
      Container(
          alignment: Alignment(0, .75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //adding the skip button

              GestureDetector(onTap: (){
                _controller.jumpToPage(2);
              },child: Text("Skip",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),

              // adding the dot indicator
              SmoothPageIndicator(controller: _controller, count: 3),

              // next and the done button
            onlastpage ?  GestureDetector(onTap: (){
                _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);
              }
                  ,child: GestureDetector(onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => walkscreen()));
                },child: Text("Done",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)))
                : GestureDetector(onTap: (){
              _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);
            }
                ,child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)),

            ],
          ),
          // next or done
      ),
        ],
      ),
    );
  }
}
