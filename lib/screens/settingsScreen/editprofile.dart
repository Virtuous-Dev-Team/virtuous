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
    TextEditingController tfName = TextEditingController();
    TextEditingController tfEmail = TextEditingController();
    TextEditingController tfCareer = TextEditingController();
    TextEditingController tfCareerTP = TextEditingController();
    List<String> yesNoDropdownValues = ['Yes', 'No'];
    String shareEntries = 'No';
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Center(
              child: SingleChildScrollView(
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
                    bottom: screenHeight / 50,
                    left: screenWidth / 30,
                    right: screenWidth / 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
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
                                setState(() {});
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
                                setState(() {});
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
                                setState(() {});
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
                                setState(() {});
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
                          DropdownButton<String>(
                            value: shareEntries,
                            items: yesNoDropdownValues
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  height:
                                      30.0, // Adjust the height of each item
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.tinos(
                                          textStyle: TextStyle()),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {},
                            dropdownColor: Colors
                                .white, // Set the background color of the dropdown
                            isDense: true, // Reduce height
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors
                                    .black), // Align the arrow to the right
                            isExpanded: true, // Extend the button to the right
                            underline: Container(),
                          ),
                        ],
                      ),
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
                          width: 210,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Update Profile",
                              style: GoogleFonts.tinos(
                                textStyle: TextStyle(
                                  fontSize: 20,
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
            )));
  }
}
