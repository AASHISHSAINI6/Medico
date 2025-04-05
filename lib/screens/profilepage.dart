import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  bool isDiabetic = false;
  double bmi = 0.0;
  File? selectedimage;
  // Function to pick an image from Camera
  Future _pickimagefromcamera() async {
    final returnedimage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedimage == null) return; // Prevent crash if user cancels

    setState(() {
      selectedimage = File(returnedimage.path);
    });
  }

  // Function to pick an image from Gallery
  Future _pickimagefromgallery() async {
    final returnedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedimage == null) return; // Prevent crash if user cancels

    setState(() {
      selectedimage = File(returnedimage.path);
    });
  }

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    if (height > 0 && weight > 0) {
      bmi = weight / ((height / 100) * (height / 100)); // BMI Formula
    }
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        calculateBMI();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile Saved Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Form")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Avatar with Image Picker
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Take photo"),
                              onTap: () {
                                Navigator.pop(context); // Close modal
                                _pickimagefromcamera();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text("Choose From Gallery"),
                              onTap: () {
                                Navigator.pop(context); // Close modal
                                _pickimagefromgallery();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: selectedimage != null
                        ? FileImage(selectedimage!)
                        : AssetImage("assets/images/doctor.jpg") as ImageProvider,
            
                  ),
                ),
            
                // Form Fields
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Patient Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the patient's name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: "Height (cm)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter height";
                    }
                    return null;
                  },
                  onChanged: (value) => calculateBMI(),
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: "Weight (kg)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter weight";
                    }
                    return null;
                  },
                  onChanged: (value) => calculateBMI(),
                ),
                Row(
                  children: [
                    Text("Diabetic: "),
                    Switch(
                      value: isDiabetic,
                      onChanged: (value) {
                        setState(() {
                          isDiabetic = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveProfile,
                  child: Text("Save Profile"),
                ),
                SizedBox(height: 20),
                Text("BMI: ${bmi.toStringAsFixed(2)}"),
                Text("Diabetic: ${isDiabetic ? "Yes" : "No"}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
