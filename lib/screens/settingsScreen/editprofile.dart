import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/widgets/reauthenticateShowDialogWidget.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';

class EditProfilePage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController newProfileName = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newCareer = TextEditingController();
  TextEditingController newCareerLength = TextEditingController();
  String currentCommunity = 'Legal';
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

    // Dropdown values for each page
    List<String> careerDropdownValues = [
      'Legal',
      'Education',
      'Technology',
      'Healthcare'
    ];

    return Consumer(builder: (context, ref, _) {
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (response['Function'] == "updateProfile") {
                  showToasty(response['msg'], true, context);
                  newProfileName.clear();
                  newEmail.clear();
                  newCareer.clear();
                  newCareerLength.clear();

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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
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
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  border: InputBorder
                                      .none, // Hide the default border
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
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
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  border: InputBorder
                                      .none, // Hide the default border
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
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
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  border: InputBorder
                                      .none, // Hide the default border
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
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
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  border: InputBorder
                                      .none, // Hide the default border
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
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
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updateProfile(
                                      newEmail: newEmail.text,
                                      newProfileName: newProfileName.text,
                                      newCareer: newCareer.text,
                                      newCommunity:
                                          currentCommunity.toLowerCase(),
                                      newCareerLength: newCareerLength.text,
                                      authError: () => {
                                            print('need to reauth'),
                                            _dialogBuilder(context)
                                            // ReauthenticateShowDialogWidget()
                                            //     .dialogBuilder(context),
                                          });
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
    });
  }
}

class ReAuthenticateUserModal extends StatelessWidget {
  const ReAuthenticateUserModal({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return AlertDialog(
        content: Column(children: [
      Form(
          // key: formGlobalKey,
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),

          SizedBox(height: 10.0),

          // password textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                prefixIcon: Icon(
                  Icons.fingerprint_outlined,
                  color: Colors.black,
                ),
              ),
              validator: validatePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ],
      )),

      const SizedBox(height: 20),

      // sign in button
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color(0xFFC1D9CD),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(1, 2))
          ],
        ),
        child: OutlinedButton(
          onPressed: () async {
            // if (formGlobalKey.currentState!.validate()) {
            print('Fields pass validation');
            // try {
            //   final authController =
            //       ref.read(authControllerProvider.notifier);

            //   await authController.signIn(email.text, password.text);
            //   ref.invalidate(authControllerProvider);
            // } catch (e) {
            //   print('Error in sig in btn container $e');
            // }
            // } else {
            //   print('Fields not passing validation');
            //   return;
            // }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFC1D9CD),
            side: BorderSide(color: Color(0xFFC1D9CD)),
          ),
          child: const Center(
            child: Text(
              "Sign In",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    ]));
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

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController email = TextEditingController();
      TextEditingController password = TextEditingController();
      final formGlobalKey = GlobalKey<FormState>();

      return Consumer(builder: (context, ref, _) {
        ref.watch(settingsControllerProvider).when(
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) {
                Future.delayed(Duration.zero, () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // ref.read(authControllerProvider.notifier).state =
                    //     AsyncLoading();
                    dynamic errorType = error;
                    if (errorType['Function'] == 'reauthenticateUser') {
                      showToasty(errorType['msg'], false, context);
                    }
                  });
                });
              },
              data: (response) async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // if (response is String) {
                  //   showToasty(response, true, context);
                  //   Navigator.pop(context);
                  // }
                  if (response['Function'] == 'reauthenticateUser') {
                    showToasty(response['msg'], true, context);
                    Navigator.pop(context);
                  }
                });
              },
            );
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
          title: const Text("Re-aunthenticate your account"),
          content: SingleChildScrollView(
              child: Form(
                  key: formGlobalKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),

                      SizedBox(height: 10.0),

                      // password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                            prefixIcon: Icon(
                              Icons.fingerprint_outlined,
                              color: Colors.black,
                            ),
                          ),
                          validator: validatePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ))),

          // sign in button

          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFC1D9CD),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 4, offset: Offset(1, 2))
                ],
              ),
              child: OutlinedButton(
                onPressed: () async {
                  if (formGlobalKey.currentState!.validate()) {
                    print('Fields pass validation ${email.text} ');
                    try {
                      final settingsController =
                          ref.read(settingsControllerProvider.notifier);

                      await settingsController.reauthenticateUser(
                          email.text, password.text);
                      ref.invalidate(settingsControllerProvider);
                    } catch (e) {
                      print('Error in sig in btn container $e');
                    }
                  } else {
                    print('Fields not passing validation');
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC1D9CD),
                  side: BorderSide(color: Color(0xFFC1D9CD)),
                ),
                child: const Center(
                  child: Text(
                    "Authenticate",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    },
  );
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
