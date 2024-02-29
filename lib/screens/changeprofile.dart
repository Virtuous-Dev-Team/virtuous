

import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../App_Configuration/apptheme.dart';
import '../widgets/appBarWidget.dart';

class ChangeProfilePage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage>
{


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
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFDF9),
                    border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding:  EdgeInsets.only(top: screenHeight/50,bottom: screenHeight/50,
                    left: screenWidth/30,right: screenWidth/30,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                        ],),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.swatch(clrBackground), // Dark purple color
                            borderRadius:
                            BorderRadius.circular(5), // Adjusted border radius
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
                              "Log Out",
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
