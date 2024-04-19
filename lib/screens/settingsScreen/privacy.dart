import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/controllers/surveyPageController.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';

import '../../App_Configuration/apptheme.dart';
import '../../App_Configuration/globalfunctions.dart';
import '../../widgets/appBarWidget.dart';

class PrivacyPage extends ConsumerStatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  bool shareEntries = false;
  bool shareLocation = false;
  dynamic userLocation = null;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoProviderr);

    shareEntries = userInfo.shareEntries;
    shareLocation = userInfo.shareLocation;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ref.watch(settingsControllerProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // ref.read(authControllerProvider.notifier).state =
                //     AsyncLoading();
                dynamic errorType = error;
                if (errorType['Function'] == 'updatePrivacy') {
                  showToasty(errorType['msg'], false, context);
                }
              });
            });
          },
          data: (response) async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (response['Function'] == "updatePrivacy") {
                showToasty(response['msg'], true, context);

                // Update UserInfo Provider
                setUserInfoProvider(ref);

                GoRouter.of(context).pop();

                // newProfileName.
              }
            });
          },
        );
    ref.watch(surveyPageControllerProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              showToasty(error.toString(), false, context);
            });
          },
          data: (response) async {
            // If response is location and not string then update userLocation
            if (response is GeoPoint) {
              print('User Location : $response');
              userLocation = response;
              return;
            }

            print("What is the response survey: $response");
            // If user has now been created in Users collection then go to Tutorial Page
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   GoRouter.of(context).go(response);
            // });
          },
        );
    return Scaffold(
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
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Would you like to participate in entry sharing?',
                          style: GoogleFonts.adamina(
                            textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colours.black),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
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
                        SizedBox(
                          height: 5,
                        ),
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
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align children vertically at the center
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
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              side: BorderSide(
                                color: Colours.swatch(clrWhite),
                              ),
                              checkColor: Colors.white,
                              value: shareEntries,
                              onChanged: (bool? value) {
                                print(value);

                                setState(() {
                                  shareEntries = value!;
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
                              value: shareLocation,
                              onChanged: (bool? value) async {
                                print(value);
                                if (value!) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref
                                      .read(
                                          surveyPageControllerProvider.notifier)
                                      .getLocation();
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                setState(() {
                                  shareLocation = value!;
                                });
                              },
                            ),

                            // Stack(
                            //   children: [
                            //     // Checkbox widget
                            //     Checkbox(
                            //       visualDensity: VisualDensity.compact,
                            //       fillColor:
                            //           MaterialStateProperty.resolveWith(
                            //               getColor),
                            //       side: BorderSide(
                            //           color: Colours.swatch(clrWhite)),
                            //       checkColor: Colors.white,
                            //       value: shareLocation,
                            //       onChanged: (bool? value) async {
                            //         print(value);
                            //         if (value!) {
                            //           // Show circular progress indicator while awaiting location
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible:
                            //       false, // Prevent user from dismissing dialog
                            //   builder: (BuildContext context) {
                            //     return Center(
                            //       child:
                            //           CircularProgressIndicator(),
                            //     );
                            //   },
                            // );
                            //           try {
                            //             // Your logic to get location
                            //             await ref
                            //                 .read(
                            //                     surveyPageControllerProvider
                            //                         .notifier)
                            //                 .getLocation();
                            //           } finally {
                            //             // Close the dialog after location is obtained or if an error occurs
                            //             Navigator.of(context).pop();
                            //           }
                            //         }
                            //         setState(() {
                            //           shareLocation = value!;
                            //         });
                            //       },
                            //     ),

                            //     // Circular progress indicator (hidden by default)
                            //     // if (shareLocation)
                            //     //   Center(
                            //     //     child: CircularProgressIndicator(),
                            //     //   ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updatePrivacy(shareEntries, shareLocation,
                                      userLocation);
                              ref.invalidate(settingsControllerProvider);
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
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "Update Privacy",
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
        ));
  }
}
