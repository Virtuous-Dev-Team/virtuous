import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

class ReauthenticateShowDialogWidget {
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

  Future<void> dialogBuilder(BuildContext context) {
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
}
