import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';

class EditProfilePage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController tfName = TextEditingController();
  TextEditingController tfEmail = TextEditingController();
  TextEditingController tfCareer = TextEditingController();
  TextEditingController tfCareerTP = TextEditingController();
  String currentCommunity = 'Legal';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Dropdown values for each page
    List<String> careerDropdownValues = [
      'Legal',
      'Education',
      'Technology',
      'Healthcare'
    ];

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFDF9),
                      border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: screenHeight / 50,
                      bottom: screenHeight / 25,
                      left: screenWidth / 30,
                      right: screenWidth / 30,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 30,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  controller: tfEmail,
                                  onChanged: (newValue) {
                                    setState(() {
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: 'Eg. abc@gmail.com',
                                    hintStyle: GoogleFonts.tinos(
                                        textStyle: TextStyle(color: Colors.black)),
                                    border:
                                        InputBorder.none, // Hide the default border
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Text(
                                'Profile Name',
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  controller: tfName,
                                  onChanged: (newValue) {
                                    setState(() {
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: 'Eg. john doe',
                                    hintStyle: GoogleFonts.tinos(
                                        textStyle: TextStyle(color: Colors.black)),
                                    border:
                                        InputBorder.none, // Hide the default border
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Text(
                                'What is your Career?',
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  controller: tfCareer,
                                  onChanged: (newValue) {
                                    setState(() {
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: 'Eg. lawyer',
                                    hintStyle: GoogleFonts.tinos(
                                        textStyle: TextStyle(color: Colors.black)),
                                    border:
                                        InputBorder.none, // Hide the default border
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Text(
                                'How long have you been in this career?',
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  controller: tfCareerTP,
                                  onChanged: (newValue) {
                                    setState(() {
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: 'Eg. 2 years',
                                    hintStyle: GoogleFonts.tinos(
                                        textStyle: TextStyle(color: Colors.black)),
                                    border:
                                        InputBorder.none, // Hide the default border
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 70,
                              ),
                              Text(
                                'Choose a community that best fits your reason for joining Virtuous.',
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.normal),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                child: Text(
                                  'Learn more about communities.',
                                  style: GoogleFonts.adamina(
                                    textStyle: TextStyle(
                                        color: Colours.swatch(clrBackground),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(minHeight: 0, maxHeight: screenHeight * 0.2), // Adjust the maxHeight according to your layout
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: DropdownButton<String>(
                                  value: currentCommunity,
                                  onChanged: (newValue) {
                                    setState(() {
                                      currentCommunity = newValue!;
                                    });
                                  },
                                  items: careerDropdownValues
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  dropdownColor: Colors
                                      .white, // Set the background color of the dropdown
                                  isDense: true, // Reduce height
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors
                                          .black), // Align the arrow to the right
                                  isExpanded: true, // Extend the button to the right
                                  underline: Container(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25,),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colours.swatch(
                                    clrBackground), // Dark purple color
                                borderRadius: BorderRadius.circular(
                                    5), // Adjusted border radius
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: 310,
                              height: 60,
                              child: Center(
                                child: Text(
                                  "Update Profile",
                                  style: GoogleFonts.tinos(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
