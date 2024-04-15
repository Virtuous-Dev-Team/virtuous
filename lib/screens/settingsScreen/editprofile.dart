import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/resourcesController.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/controllers/statsController.dart';
import 'package:virtuetracker/controllers/virtueEntryController.dart';
import 'package:virtuetracker/main.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/widgets/reauthenticateShowDialogWidget.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  TextEditingController newProfileName = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newCareer = TextEditingController();
  TextEditingController newCareerLength = TextEditingController();
  late String currentCommunity;
  bool newListExist = false;
  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    print('edit profile : ${userInfo.currentCommunity}');
    currentCommunity = userInfo.currentCommunity;

    // if (currentCommunity == 'legal')
    //   currentCommunity = currentCommunity.capitalizeFirst!;
    newCareer.text = userInfo.careerInfo.currentPosition;
    newCareerLength.text = userInfo.careerInfo.careerLength;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // Dropdown values for each page
    List<String> careerDropdownValues = [
      'Legal',
      'Alcoholics Anonymous',
    ];
    // var count = ref.watch<UserInfoProvider>().currentCommunity;

    // final userInfoProvider =
    //     ChangeNotifierProvider((ref) => UserInfoProvider());

    // _readUserInfo() async {
    //   final result = await ref.read(usersRepositoryProvider).getUserInfo();
    //   if (result['Success']) {
    //     print('edit profile: _readUserInfo: ${result['response']}');
    //   }
    // }
    // final u = _readUserInfo();
    ref.watch(settingsControllerProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // ref.read(authControllerProvider.notifier).state =
                //     AsyncLoading();
                dynamic errorType = error;
                if (errorType['Function'] == 'updateProfile') {
                  showToasty(errorType['msg'], false, context);
                }
              });
            });
          },
          data: (response) async {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (response['Function'] == "updateProfile") {
                showToasty(response['msg'], true, context);
                newProfileName.clear();
                newEmail.clear();
                newCareer.clear();
                newCareerLength.clear();
                // Update UserInfo Provider
                await setUserInfoProvider(ref);
                await ref
                    .read(resourcesControllerProvider.notifier)
                    .getResources(currentCommunity);
                await ref
                    .read(virtueEntryControllerProvider.notifier)
                    .getMostRecentEntries(currentCommunity);
                await ref
                    .read(statsControllerProvider.notifier)
                    .getAllStats(currentCommunity);
                GoRouter.of(context).pop();

                // newProfileName.
              }
            });
          },
        );
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
                        "Edit Profile",
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
                          Text(
                            'Email',
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
                              controller: newEmail,
                              // onChanged: (newValue) {
                              //   setState(() {});
                              // },
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
                            'Profile Name',
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
                              controller: newProfileName,
                              // onChanged: (newValue) {
                              //   setState(() {});
                              // },
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
                          SizedBox(
                            height: screenHeight / 70,
                          ),
                          Text(
                            'What is your Career?',
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
                              controller: newCareer,
                              // onChanged: (newValue) {
                              //   setState(() {});
                              // },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Eg. lawyer',
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
                            'How long have you been in this career?',
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
                              controller: newCareerLength,
                              // onChanged: (newValue) {
                              //   setState(() {});
                              // },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Eg. 2 years',
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
                            'Choose a community that best fits your reason for joining Virtuous.',
                            style: GoogleFonts.adamina(
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Learn more about communities.',
                              style: GoogleFonts.adamina(
                                textStyle: TextStyle(
                                    color: Colours.swatch(clrBackground),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
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
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors
                                      .black), // Align the arrow to the right
                              isExpanded:
                                  true, // Extend the button to the right
                              underline: Container(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            if (newEmail.text.isEmpty &&
                                newProfileName.text.isEmpty &&
                                newCareer.text.isEmpty &&
                                newCareerLength.text.isEmpty) {
                              return;
                            }
                            final userInfo = ref.read(userInfoProviderr);
                            final quadrantUsedData = userInfo.quadrantUsedData;
                            final newListExistInProfile =
                                quadrantUsedData[currentCommunity];
                            print("edit profile page $newListExistInProfile");
                            if (newListExistInProfile != null) {
                              print('in here');
                              newListExist = true;
                            }
                            ref
                                .read(settingsControllerProvider.notifier)
                                .updateProfile(
                                    newEmail: newEmail.text,
                                    newProfileName: newProfileName.text,
                                    newCareer: newCareer.text,
                                    newCommunity: currentCommunity,
                                    newCareerLength: newCareerLength.text,
                                    authError: () => {
                                          print('need to reauth'),
                                          // _dialogBuilder(context)
                                          ReauthenticateShowDialogWidget()
                                              .dialogBuilder(context),
                                        },
                                    newListExist: newListExist);
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
                              child: Text(
                                "Update Profile",
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

void showToasty(msg, bool success, BuildContext context) {
  print('calling toast widget in sign in page');
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ToastNotificationWidget().successOrError(
      context,
      msg,
      success,
    );
  });
}

String? validateEmail(String? email) {
  RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailRegex.hasMatch(email ?? '');
  if (!isEmailValid) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? pass) {
  RegExp passRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final isPassValid = passRegex.hasMatch(pass ?? '');
  if (!isPassValid) {
    return 'Please enter a stronger password';
  }
  return null;
}
