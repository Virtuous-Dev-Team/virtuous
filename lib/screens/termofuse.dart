

import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../App_Configuration/apptheme.dart';
import '../widgets/appBarWidget.dart';

class TermOfUsePage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _TermOfUsePageState createState() => _TermOfUsePageState();
}

class _TermOfUsePageState extends State<TermOfUsePage>
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
            body: Center(
              child:SingleChildScrollView(
                child: Container(
                  width: screenWidth,
                  height: screenHeight/1.2,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Terms of Use",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight/40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Modified on 02/14/2024',
                            style: GoogleFonts.adamina(
                              textStyle: TextStyle(
                                  fontSize: 13,fontWeight: FontWeight.normal,
                                  color: Colours.black
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight/50,
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Penatibus et magnis dis parturient montes nascetur ridiculus. Viverra orci sagittis eu volutpat odio facilisis. Tincidunt augue interdum velit euismod in. Aliquam eleifend mi in nulla posuere sollicitudin aliquam ultrices sagittis. Praesent tristique magna sit amet purus gravida quis. Aliquet porttitor lacus luctus accumsan tortor posuere. Lacus vel facilisis volutpat est velit. Magna eget est lorem ipsum dolor. Amet tellus cras adipiscing enim eu turpis egestas pretium aenean.',
                            style: GoogleFonts.adamina(
                              textStyle: TextStyle(
                                  fontSize: 13,fontWeight: FontWeight.normal,
                                  color: Colours.swatch(clrText)
                              ),
                            ),
                          ),
                        ],),

                    ],
                  ),

                ),
              ),
            )));
  }
}
