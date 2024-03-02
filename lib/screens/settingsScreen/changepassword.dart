import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';

class ChangePasswordPage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
    TextEditingController tfNewPass = TextEditingController();
    TextEditingController tfCPass = TextEditingController();

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  height: screenHeight / 1.2,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15,),
                      Text(
                        "Change Password",
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
                            'Enter New Password',
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
                              controller: tfNewPass,
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
                            'Confirm New Password',
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
                              controller: tfCPass,
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
                        ],
                      ),
                      SizedBox(
                        height: 40,
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
                          width: 310,
                          height: 60,
                          child: Center(
                            child: Text(
                              "Change Password",
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
            )));
  }
}
