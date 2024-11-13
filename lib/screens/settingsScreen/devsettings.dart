import 'package:colours/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/controllers/communityCreationController.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/controllers/userControllers.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/controllers/statsController.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/settingsScreen/devsettings.dart';
import 'package:virtuetracker/screens/settingsScreen/addcommunity.dart';
import 'package:virtuetracker/main.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/widgets/reauthenticateShowDialogWidget.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

import '../../widgets/appBarWidget.dart';
import 'changepassword.dart';

class DevSettingsPage extends ConsumerStatefulWidget {
  //const DevSettingsPage({super.key});

  @override
  _DevSettingsPageState createState() => _DevSettingsPageState();
}

class _DevSettingsPageState extends ConsumerState<DevSettingsPage> {
  // TextEditingController newProfileName = TextEditingController();
  // TextEditingController newEmail = TextEditingController();
  // TextEditingController newCareer = TextEditingController(); //newRole
  // TextEditingController newCareerLength = TextEditingController(); //newLength
  late String currentCommunity = 'Legal';
  // bool newListExist = false;
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
                    "Community Settings",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                     height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                "New Community",
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
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      Text(
                        'Community Select',
                        style: GoogleFonts.adamina(
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      // This would be a community dropdown 
                      // that autofills the page based on the virtue selected
                      // and it could have an option for new that doesn't autofill
                      Container(
                        constraints: BoxConstraints(
                            minHeight: 0,
                            maxHeight: screenHeight *
                                0.2), // Adjust the maxHeight according to your layout
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
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: Colors
                              .white, // Set the background color of the dropdown
                          isDense: true, // Reduce height
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black
                          ), // Align the arrow to the right
                          isExpanded:
                              true, // Extend the button to the right
                          underline: Container(),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      Text(
                        'Community Name',
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
                          // controller: ,
                          // onChanged: (newValue) {
                          //   setState(() {});
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
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
                        'Community Description',
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
                          // controller: ,
                          // onChanged: (newValue) {
                          //   setState(() {});
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
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
                                "New Virtue",
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
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      Text(
                        'Virtue Select',
                        style: GoogleFonts.adamina(
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      // This would be a virtue dropdown 
                      // that autofills the page based on the virtue selected
                      // and it could have an option for new that doesn't autofill
                      Container(
                        constraints: BoxConstraints(
                            minHeight: 0,
                            maxHeight: screenHeight *
                                0.2), // Adjust the maxHeight according to your layout
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
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: Colors
                              .white, // Set the background color of the dropdown
                          isDense: true, // Reduce height
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black
                          ), // Align the arrow to the right
                          isExpanded:
                              true, // Extend the button to the right
                          underline: Container(),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 70,
                      ),
                      Text(
                        'Virtue Name',
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
                          //controller: ,
                          // onChanged: (newValue) {
                          //   setState(() {});
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
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
                        'Definition',
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
                          //controller: ,
                          // onChanged: (newValue) {
                          //   setState(() {});
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
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
                        'Color Code',
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
                          //controller: ,
                          // onChanged: (newValue) {
                          //   setState(() {});
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintStyle: GoogleFonts.tinos(
                                textStyle: TextStyle(color: Colors.black)),
                            border:
                                InputBorder.none, // Hide the default border
                          ),
                        ),
                      ),
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
                                "Update Community",
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
                ],
              ),
              ),
            ),
          ),
        ),
      ));
  }
}

// void showToasty(msg, bool success, BuildContext context) {
//   print('calling toast widget in sign in page');
//   WidgetsBinding.instance?.addPostFrameCallback((_) {
//     ToastNotificationWidget().successOrError(
//       context,
//       msg,
//       success,
//     );
//   });
// }

// String? validateEmail(String? email) {
//   RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
//   final isEmailValid = emailRegex.hasMatch(email ?? '');
//   if (!isEmailValid) {
//     return 'Please enter a valid email';
//   }
//   return null;
// }

// String? validatePassword(String? pass) {
//   RegExp passRegex =
//       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
//   final isPassValid = passRegex.hasMatch(pass ?? '');
//   if (!isPassValid) {
//     return 'Please enter a stronger password';
//   }
//   return null;
// }

                  // InkWell(
                  //     onTap: () {
                  //       GoRouter.of(context)
                  //           .go('/SettingsPage/DevSettingsPage/AddCommunityPage');
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "New Community",
                  //           style: TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.normal,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.arrow_right,
                  //           size: 25,
                  //         )
                  //       ],
                  //     ),
                  // ),
                  // SizedBox(
                  //     height: 25,
                  // ),
                  // SizedBox(
                  //   height: screenHeight / 70,
                  // ),
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