

import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/screens/editprofile.dart';
import 'package:virtuetracker/screens/notifications.dart';
import 'package:virtuetracker/screens/privacy.dart';
import 'package:virtuetracker/screens/privacypolicy.dart';
import 'package:virtuetracker/screens/termofuse.dart';

import '../App_Configuration/apptheme.dart';
import '../widgets/appBarWidget.dart';
import 'changepassword.dart';

class SettingsPage extends StatefulWidget {
 // const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
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
              child: SingleChildScrollView(
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
                        InkWell(
                          onTap: (){
                            GoRouter.of(context).go('/SettingsPage/EditProfilePage');
                            // Navigator.pushReplacement(
                            //   context,
                            //   CupertinoPageRoute(builder: (context) => EditProfilePage()),
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            GoRouter.of(context).go('/SettingsPage/ChangePasswordPage');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            GoRouter.of(context).go('/SettingsPage/NotificationsPage');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Notifications",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            GoRouter.of(context).go('/SettingsPage/PrivacyPage');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Privacy",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            GoRouter.of(context).go('/SettingsPage/TermOfUsePage');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terms of Use",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            
                            GoRouter.of(context).go('/SettingsPage/PrivacyPolicyPage');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.arrow_right,size: 25,)
                            ],
                          ),
                        ),
                      ],),
                      Center(
                        child: MaterialButton(
                          onPressed: (){



                            },
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
                      ),
                    ],
                  ),
                            
                ),
              ),
            )));
  }
}
