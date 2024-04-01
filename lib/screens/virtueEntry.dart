import 'dart:ffi';

import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import 'package:virtuetracker/controllers/statsController.dart';
import 'package:virtuetracker/controllers/virtueEntryController.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import '../App_Configuration/apptheme.dart';
import '../App_Configuration/globalfunctions.dart';
import '../widgets/appBarWidget.dart';

class VirtueEntry extends ConsumerStatefulWidget {
  final String? quadrantName;
  final String? definition;
  final String? color;
  VirtueEntry(
      {super.key,
      required this.quadrantName,
      required this.definition,
      required this.color});

  @override
  _VirtueEntryState createState() => _VirtueEntryState();
}

class _VirtueEntryState extends ConsumerState<VirtueEntry> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    shareEntry = userInfo.shareEntries;
    shareLocation = userInfo.shareLocation;
    communityName = userInfo.currentCommunity;
    tfDescription.text = '';
    tfAdvice.text = '';
    DateTime now = DateTime.now();
    // Format the date as a string (e.g., "2/20/24")
    tfDate.text = DateFormat('M/d/yy').format(now);
    // Format the time as a string (e.g., "2:20pm")
    tfTime.text = DateFormat('h:mma').format(now);
  }

  late bool shareEntry;
  late bool shareLocation;
  late String communityName;
  bool isLoading = false;
  final PageController _pageController = PageController();
  List<Events> eventList = [
    Events('Tv', false),
    Events('In a Meeting', false),
    Events('Emails', false), //Reading EMails is 2 long
    Events('Driving', false),
    Events('Eating', false),
    Events('Exercising', false),
    Events('Commuting', false),
    Events('Working', false),
    Events('Other', false)
  ];

  List<Events> whoWereWithYouList = [
    Events('Pet', false),
    Events('Co-Workers', false),
    Events('Family', false),
    Events('No one', false),
    Events('Friends', false),
    Events('Other', false)
  ];
  List<Events> whereWereYouList = [
    Events('Work', false),
    Events('Home', false),
    Events('Outdoors', false),
    Events('School', false),
    Events('Commuting', false),
    Events('Other', false)
  ];
  List<String> sleepingHoursList = ['1', '2', '3', '4'];
  String sleepingHours = '';
  // you can send this data from backend

  TextEditingController tfDate = TextEditingController();
  TextEditingController tfTime = TextEditingController();
  TextEditingController tfDescription = TextEditingController();
  TextEditingController tfAdvice = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print('color in virtue entry: ${widget.color}');
    ref.watch(virtueEntryControllerProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // ref.read(authControllerProvider.notifier).state =
                //     AsyncLoading();
                dynamic errorType = error;
                if (errorType['Function'] == 'addEntry') {
                  showToasty(errorType['msg'], false, context);
                }
              });
            });
          },
          data: (response) async {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (response['Function'] == "addEntry") {
                showToasty(response['msg'], true, context);
                tfAdvice.clear();
                tfDescription.clear();
                tfDate.clear();
                tfTime.clear();
                // Update UserInfo Provider
                setUserInfoProvider(ref);
                await ref
                    .read(virtueEntryControllerProvider.notifier)
                    .getMostRecentEntries(communityName.toLowerCase());
                await ref
                    .read(statsControllerProvider.notifier)
                    .getAllStats(communityName.toLowerCase());
                GoRouter.of(context).go('/home');

                // newProfileName.
              }
            });
          },
        );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: mainBackgroundColor,
        //appBar: AppBarWidget('Tutorial'),             UNCOMMENT
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 30, color: iconColor),
              onPressed: () {
                // TODO: Implement profile icon functionality.
              },
            ),
            SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildVirtueEntry1(context, screenWidth, screenHeight),
                      buildVirtueEntry2(context, screenWidth, screenHeight,
                          quadrantName: widget.quadrantName!,
                          definition: widget.definition!,
                          color: widget.color!),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                      dotColor: Colours.swatch("#EFE5CC"),
                      activeDotColor: Colours.swatch("#C5B898"),
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
// Bottom navigation bar code would be here
      ),
    );
  }

  Widget buildVirtueEntry1(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              '     What were you doing when you modeled this virtue?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),
            Divider(
              thickness: 2,
              color: legalVirtueColors[widget.quadrantName!],
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              'Date of Occurrence ${tfDate.text}, ${tfTime.text}',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
            SizedBox(height: 5,),
            Row(
              children: [
                 SizedBox(
                    height: 30.0, // Adjust the height as needed
                    child: OutlinedButton(
                      onPressed: () {
                      _selectTime(context, tfTime);
                      },
                      style: OutlinedButton.styleFrom(
                        // Define button shape as rectangular
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
                        ),
                        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
                      ),
                      child: Text(
                        "Pick Time",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 10,),
                SizedBox(
                  height: 30.0, // Adjust the height as needed
                  child: OutlinedButton(
                    onPressed: () {
                      _selecteDate(context, DateTime.now(), tfDate);
                    },
                    style: OutlinedButton.styleFrom(
                      // Define button shape as rectangular
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
                    ),
                    child: Text(
                      "Pick Date",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              'What event was happening?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 65,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[0].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[0].isSelected == true) {
                            eventList[0].isSelected = false;
                          } else {
                            eventList[0].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[0].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[0].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                      width: 125,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colours.swatch(eventList[1].isSelected!
                              ? clrPurple
                              : clrWhite),
                          borderRadius: BorderRadius.circular(10)),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                if (eventList[1].isSelected == true) {
                                  eventList[1].isSelected = false;
                                } else {
                                  eventList[1].isSelected = true;
                                }
                              });
                            },
                            child: Text(
                              eventList[1].eventName.toString(),
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colours.swatch(eventList[1].isSelected!
                                      ? clrWhite
                                      : clrBlack),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[2].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[2].isSelected == true) {
                            eventList[2].isSelected = false;
                          } else {
                            eventList[2].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[2].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[2].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 95,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[3].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[3].isSelected == true) {
                            eventList[3].isSelected = false;
                          } else {
                            eventList[3].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[3].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[3].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[4].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[4].isSelected == true) {
                            eventList[4].isSelected = false;
                          } else {
                            eventList[4].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[4].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[4].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[5].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[5].isSelected == true) {
                            eventList[5].isSelected = false;
                          } else {
                            eventList[5].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[5].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[5].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[6].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[6].isSelected == true) {
                            eventList[6].isSelected = false;
                          } else {
                            eventList[6].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[6].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[6].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[7].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[7].isSelected == true) {
                            eventList[7].isSelected = false;
                          } else {
                            eventList[7].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[7].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[7].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(eventList[8].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (eventList[8].isSelected == true) {
                            eventList[8].isSelected = false;
                          } else {
                            eventList[8].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        eventList[8].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(eventList[8].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Text(
              'Who were you with?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[0].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[0].isSelected == true) {
                            whoWereWithYouList[0].isSelected = false;
                          } else {
                            whoWereWithYouList[0].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[0].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[0].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[1].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[1].isSelected == true) {
                            whoWereWithYouList[1].isSelected = false;
                          } else {
                            whoWereWithYouList[1].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[1].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[1].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[2].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[2].isSelected == true) {
                            whoWereWithYouList[2].isSelected = false;
                          } else {
                            whoWereWithYouList[2].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[2].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[2].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 95,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[3].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[3].isSelected == true) {
                            whoWereWithYouList[3].isSelected = false;
                          } else {
                            whoWereWithYouList[3].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[3].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[3].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 95,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[4].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[4].isSelected == true) {
                            whoWereWithYouList[4].isSelected = false;
                          } else {
                            whoWereWithYouList[4].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[4].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[4].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whoWereWithYouList[5].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whoWereWithYouList[5].isSelected == true) {
                            whoWereWithYouList[5].isSelected = false;
                          } else {
                            whoWereWithYouList[5].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whoWereWithYouList[5].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whoWereWithYouList[5].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Text(
              'Where were you?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[0].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[0].isSelected == true) {
                            whereWereYouList[0].isSelected = false;
                          } else {
                            whereWereYouList[0].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[0].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[0].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[1].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[1].isSelected == true) {
                            whereWereYouList[1].isSelected = false;
                          } else {
                            whereWereYouList[1].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[1].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[1].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 105,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[2].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[2].isSelected == true) {
                            whereWereYouList[2].isSelected = false;
                          } else {
                            whereWereYouList[2].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[2].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[2].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[3].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[3].isSelected == true) {
                            whereWereYouList[3].isSelected = false;
                          } else {
                            whereWereYouList[3].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[3].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[3].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[4].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[4].isSelected == true) {
                            whereWereYouList[4].isSelected = false;
                          } else {
                            whereWereYouList[4].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[4].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[4].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colours.swatch(whereWereYouList[5].isSelected!
                            ? clrPurple
                            : clrWhite),
                        borderRadius: BorderRadius.circular(10)),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (whereWereYouList[5].isSelected == true) {
                            whereWereYouList[5].isSelected = false;
                          } else {
                            whereWereYouList[5].isSelected = true;
                          }
                        });
                      },
                      child: Text(
                        whereWereYouList[5].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colours.swatch(whereWereYouList[5].isSelected!
                                ? clrWhite
                                : clrBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15,),

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
                onChanged: (newValue) {
                  setState(() {
                    sleepingHours = newValue!;
                  });
                },
                hint: const Text(
                    "  How much sleep did you get the night before?",
                    style: TextStyle(fontSize: 14.0),
                  ),
                items: sleepingHoursList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                dropdownColor:
                    Colors.white, // Set the background color of the dropdown
                isDense: true, // Reduce height
                icon: Icon(Icons.arrow_drop_down,
                    color: Colors.black), // Align the arrow to the right
                isExpanded: true, // Extend the button to the right
                underline: Container(),
              ),
            ),

            // Other widgets or content can go here
          ],
        ),
      ),
    );
  }

  Widget buildVirtueEntry2(
      BuildContext context, double screenWidth, double screenHeight,
      {required String quadrantName,
      required String definition,
      required String color}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(quadrantName),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(definition),
                )
              ],
            ),
            Divider(
              thickness: 2,
              color: legalVirtueColors[widget.quadrantName!],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Take a moment to write about what happened.               What made it meaningful to you?",
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colours.swatch("#000000"),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.0),
            textFieldNoteInput(context, tfDescription, false),
            SizedBox(
              height: 8.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What is the best piece of advice you could give    someone about modeling this virtue throughout            the day?",
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colours.swatch("#000000"),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            textFieldNoteInput(context, tfAdvice, false),
            SizedBox(height: 28.0),
            MaterialButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await ref.read(virtueEntryControllerProvider.notifier).addEntry(
                      communityName.toLowerCase(),
                      widget.quadrantName!,
                      widget.color!,
                      shareLocation,
                      shareEntry,
                      sleepingHours,
                      tfAdvice.text,
                      tfDescription.text,
                      eventList,
                      whoWereWithYouList,
                      whereWereYouList,
                      '${tfDate.text}, ${tfTime.text}',
                    );
                setState(() {
                  isLoading = false;
                });
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFbab7d4), // Dark purple color
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
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "Save Entry",
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
    );
  }

  _selecteDate(BuildContext context, DateTime selectedDate,
      TextEditingController tfDate) async {
    final DateTime? picked = await showDatePicker(
      confirmText: "Select",
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colours.swatch(clrBlack), // header background color
                onPrimary: Colours.swatch(clrWhite), // header text color
                onSurface: Colours.swatch(clrBlack),
                // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colours.swatch(clrBlack),

                  // button text color
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: child,
                ),
              ],
            ));
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1985),
      lastDate: DateTime(DateTime.now().year + 1),
      context: context,
    );
    print("Picked Date:$picked");
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        tfDate.text = DateFormat('M/d/yy').format(picked);
      });

      print("Picked Now:$picked");
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colours.swatch(clrBlack), // header background color
              onPrimary: Colours.swatch(clrWhite), // header text color
              onSurface: Colours.swatch(clrBlack), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colours.swatch(clrBlack),

                // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != controller) {
      //widget._selectedTime = pickedTime;
      setState(() {
        controller.text = formatTime(pickedTime);
      });
    }
  }
}

Widget textFieldNoteInput(
    BuildContext context, TextEditingController controller, bool readOnly) {
  return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 120,
      child: TextFormField(
        cursorColor: Colors.black,
        cursorRadius: const Radius.circular(0),
        controller: controller,
        maxLines: 4,
        readOnly: readOnly,
        style: TextStyle(color: iconColor, fontSize: 16),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Colors.white),
      ));
}
