import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/controllers/userControllers.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/settingsScreen/devsettings.dart';
import 'package:virtuetracker/screens/settingsScreen/crudcommunities.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';
import 'changepassword.dart';

class DevSettingsPage extends ConsumerStatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _DevSettingsPageState createState() => _DevSettingsPageState();
}

class _DevSettingsPageState extends ConsumerState<DevSettingsPage> {
  TextEditingController newProfileName = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newCareer = TextEditingController(); //newRole
  TextEditingController newCareerLength = TextEditingController(); //newLength
  late String currentCommunity;
  bool newListExist = false;
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

    List<String> careerDropdownValues = [
        'Legal',
        'Alcoholics Anonymous',
    ];

    return Scaffold(
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
                    "Communities",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Container(
                  //       child:
                  //        ListView.builder(
                  //         itemCount: careerDropdownValues.length,
                  //         itemBuilder: (context, index) {
                  //           return MaterialButton(
                  //               onPressed: () {
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   color: Colours.swatch(
                  //                       clrBackground), // Dark purple color
                  //                   borderRadius: BorderRadius.circular(
                  //                       5), // Adjusted border radius
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: Colors.grey.withOpacity(0.5),
                  //                       spreadRadius: 2,
                  //                       blurRadius: 4,
                  //                       offset: Offset(0, 3),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 width: 210,
                  //                 height: 50,
                  //                 child: Center(
                  //                   child: Text(
                  //                     "Edit ${careerDropdownValues[index]} Community",
                  //                     style: GoogleFonts.tinos(
                  //                       textStyle: TextStyle(
                  //                         fontSize: 20,
                  //                         fontWeight: FontWeight.normal,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //         }
                  //       ),
                  // ),
                  SizedBox(
                      height: 25,
                  ),
                   Center(
                    child: MaterialButton(
                      onPressed: () {
                      },
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
                            "Add Community",
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
          ),
        ),
      ));
  }
}