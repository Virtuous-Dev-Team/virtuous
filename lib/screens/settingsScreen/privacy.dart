import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../App_Configuration/apptheme.dart';
import '../../App_Configuration/globalfunctions.dart';
import '../../widgets/appBarWidget.dart';

class PrivacyPage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);
  bool cbShareEntries = false;
  bool cbShareLocations = false;
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
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
                      SizedBox(
                        height: screenHeight / 40,
                      ),
                      Text(
                        "Privacy",
                        style: GoogleFonts.adamina(
                          textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(
                              'Would you like to participate in entry sharing?',
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colours.black),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'If you select “Yes,” your data may be shown to other users. Your personal information won’t be shared, only your virtue usage.',
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colours.swatch(clrText)),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight / 70,
                            ),
                            Text(
                              'Would you like to share your location?',
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colours.black),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'We will not share your location with other users. However you can’t use some features without location tuned on.',
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colours.swatch(clrText)),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight / 70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically at the center
                              children: [
                                Text(
                                  "Share Entries   ",
                                  style: GoogleFonts.adamina(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth / 50,
                                ),
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                  side: BorderSide(
                                    color: Colours.swatch(clrWhite),
                                  ),
                                  checkColor: Colors.white,
                                  value: widget.cbShareEntries,
                                  onChanged: (bool? value) {
                                    print(value);

                                    setState(() {
                                      widget.cbShareEntries = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Share Location",
                                  style: GoogleFonts.adamina(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth / 50,
                                ),
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  fillColor:
                                      MaterialStateProperty.resolveWith(getColor),
                                  side: BorderSide(
                                    color: Colours.swatch(clrWhite),
                                  ),
                                  checkColor: Colors.white,
                                  value: widget.cbShareLocations,
                                  onChanged: (bool? value) {
                                    print(value);

                                    setState(() {
                                      widget.cbShareLocations = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              "Submit",
                              style: GoogleFonts.adamina(
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
