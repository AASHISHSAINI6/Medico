import 'package:flutter/material.dart';

class walk3 extends StatefulWidget {
  final VoidCallback nextPage;
  const walk3({super.key, required this.nextPage});

  @override
  State<walk3> createState() => _Walk3State();
}

class _Walk3State extends State<walk3> {
  bool isCmSelected = true; // Default: Cm
  double heightValue = 80;  // Default height in cm
  TextEditingController heightController = TextEditingController(text: "80");

  // Convert height when unit changes
  void toggleUnit(String unit) {
    setState(() {
      if (unit == "Cm" && !isCmSelected) {
        // Convert from ft to cm (1 ft = 30.48 cm)
        heightValue = double.tryParse(heightController.text) ?? 2.6;
        heightValue *= 30.48;
        heightController.text = heightValue.toStringAsFixed(0);
      } else if (unit == "Ft" && isCmSelected) {
        // Convert from cm to ft (1 cm = 0.0328 ft)
        heightValue = double.tryParse(heightController.text) ?? 80;
        heightValue *= 0.0328;
        heightController.text = heightValue.toStringAsFixed(1);
      }
      isCmSelected = (unit == "Cm");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80),
              Text("How Tall Are You?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 150),
        
              // TextField for User Input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 80, // Adjust width as needed
                    child: TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      onChanged: (value) {
                        setState(() {
                          heightValue = double.tryParse(value) ?? heightValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(isCmSelected ? "Cm" : "Ft", style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(height: 20),
        
              // Toggle Buttons for Unit Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _unitButton("Ft", !isCmSelected),
                    _unitButton("Cm", isCmSelected),
                  ],
                ),
              ),
              SizedBox(height: 250),
        
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                onPressed: () => widget.nextPage(),
                child: Text("Continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _unitButton(String unit, bool isSelected) {
    return GestureDetector(
      onTap: () => toggleUnit(unit),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade50 : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: unit == "Ft" ? Radius.circular(30) : Radius.zero,
            right: unit == "Cm" ? Radius.circular(30) : Radius.zero,
          ),
        ),
        child: Text(
          unit,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.teal : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
