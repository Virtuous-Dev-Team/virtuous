import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';

import '../../App_Configuration/apptheme.dart';
import '../../App_Configuration/globalfunctions.dart';
import '../../widgets/appBarWidget.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool enableNotifications = false;
  bool onChanged = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController notificationTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    enableNotifications = userInfo.notificationPreferences.allowNotifications;
    notificationTime.text = userInfo.notificationPreferences.notificationTime;
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
              if (errorType['Function'] == 'updateNotificationPreferences') {
                showToasty(errorType['msg'], false, context);
              }
            });
          });
        },
        data: (response) async {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (response['Function'] == "updateNotificationPreferences") {
              showToasty(response['msg'], true, context);
              setUserInfoProvider(ref);
              GoRouter.of(context).pop();

              // newProfileName.
            }
          });
        });
    return Scaffold(
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
              padding: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 30,
                right: screenWidth / 30,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).go(
                                '/SettingsPage/NotificationsPage/UpdatePhoneNumber');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phone number",
                                style: GoogleFonts.adamina(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 25,
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Reminders  ",
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                  fontSize: 16,
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
                              value: enableNotifications,
                              onChanged: (bool? value) {
                                print(value);

                                setState(() {
                                  enableNotifications = value!;
                                  onChanged = true;
                                });
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context, notificationTime);
                            onChanged = true;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colours.swatch(
                                  clrBackground), // Dark purple color
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: screenWidth / 1.1,
                            height: 40,
                            child: Center(
                              child: Text(
                                "Select a time to receive notifications",
                                style: GoogleFonts.tinos(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight / 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Notification Time",
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 50,
                            ),
                            Container(
                              width: screenWidth / 4,
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFCEC0A1),
                                  width: 2.0, // Set the border width
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child:
                                  //textFieldTimeInput(context,notificationTime,"Start Time"),
                                  TextField(
                                enabled: false,
                                controller: notificationTime,
                                onChanged: (newValue) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: '   12:00pm',
                                  hintStyle: GoogleFonts.tinos(
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  border: InputBorder
                                      .none, // Hide the default border
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // Center(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colours.swatch(
                    //           clrBackground), // Dark purple color
                    //       borderRadius: BorderRadius.circular(
                    //           5), // Adjusted border radius
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           spreadRadius: 2,
                    //           blurRadius: 4,
                    //           offset: Offset(0, 3),
                    //         ),
                    //       ],
                    //     ),
                    //     width: 310,
                    //     height: 60,
                    //     child: Center(
                    //       child: Text(
                    //         "Submit",
                    //         style: GoogleFonts.tinos(
                    //           textStyle: TextStyle(
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.normal,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          if (onChanged) {
                            ref
                                .read(settingsControllerProvider.notifier)
                                .updateNotificationPreferences(
                                    enableNotifications, notificationTime.text);

                            ref.invalidate(settingsControllerProvider);
                          }
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
                              "Update Notifications",
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
        ));
  }

  Widget textFieldTimeInput(
      BuildContext context, TextEditingController controller, String hintText,
      [String? clrBasic, String? clrIcon, String? clrDivider]) {
    return InkWell(
      onTap: () {
        _selectTime(context, controller);
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          height: 40,
          child: TextFormField(
            enabled: false,
            cursorColor: Colours.swatch(clrBlack),
            cursorRadius: const Radius.circular(0),
            controller: controller,
            /*   validator: (value){
              if (value!.isEmpty
              ){
                return "enter $hintText";
              }
              else {
                return null;
              }
            },*/

            style: TextStyle(
                color: clrBasic == null
                    ? Colours.swatch(clrWhite)
                    : Colours.swatch(clrBasic),
                fontFamily: "Poppins",
                fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: '',
              hintStyle:
                  GoogleFonts.tinos(textStyle: TextStyle(color: Colors.black)),
              border: InputBorder.none, // Hide the default border
            ),
          )),
    );
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

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        //widget._selectedTime = pickedTime;

        notificationTime.text = formatTime(pickedTime);
      });
    }
  }
}
