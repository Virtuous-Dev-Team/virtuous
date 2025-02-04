// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:virtuetracker/dialogs/legal_dialog.dart';

Future<dynamic> callAuthCreateAccount(
    email, password, fullName, context, ref) async {
  final Auth auth = Auth();
  String emailInput = email.text;
  String fullNameInput = fullName.text;
  String passwordInput = password.text;
  Toastification toasty = Toastification();

  try {
    // toasty.show(context: context);
    if (emailInput.isNotEmpty &&
        fullNameInput.isNotEmpty &&
        passwordInput.isNotEmpty) {
      dynamic result =
          await auth.createAccount(emailInput, passwordInput, fullNameInput);
      if (result['Success']) {
        return {
          'Success': result['Success'],
          'msg': "Account created successfully"
        };
      } else {
        print('Error ${result}');

        return {'Success': result['Success'], 'msg': result['Error']};
      }
    } else {return {'Success': false, 'msg': 'All fields must be filled out'};}
  } catch (error) {
    print(error);
  }
}

final checkboxProvider = StateProvider<bool>((ref) => false);

class SignUpPage extends ConsumerWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController password = TextEditingController();

  final ValueNotifier<bool> hasUpperCase = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasLowerCase = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasNumber = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasSpecialChar = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasMinLength = ValueNotifier<bool>(false);

  void validatePassword(String password) {
    hasUpperCase.value = RegExp(r'(?=.*[A-Z])').hasMatch(password);
    hasLowerCase.value = RegExp(r'(?=.*[a-z])').hasMatch(password);
    hasNumber.value = RegExp(r'(?=.*[0-9])').hasMatch(password);
    hasSpecialChar.value = RegExp(r'(?=.*[!@#\\$&*~])').hasMatch(password);
    hasMinLength.value = password.length >= 8;
  }

  Widget buildPasswordRequirement(String label, ValueNotifier<bool> notifier) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: value ? Colors.green : Colors.red,
              size: 18,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: value ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formGlobalKey = GlobalKey<FormState>();

    final isChecked = ref.watch(checkboxProvider);
    final checkboxNotifier = ref.read(checkboxProvider.notifier);

    double? spacing = 5;
    void showToasty(String msg, bool success) {
      ToastNotificationWidget().successOrError(context, msg, success);
    }

    ref.watch(authControllerProvider).when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              dynamic errorType = error;
              if (errorType['Function'] == 'createAccount') {
                showToasty(errorType['msg'], false);
              }
            });
          },
          data: (response) {
            Future.delayed(Duration.zero, () {
              GoRouter.of(context).go(response);
            });
          },
        );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFFFFDF9),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => GoRouter.of(context).pop(),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // SizedBox(height: 50),
              Container(
                height: MediaQuery.of(context).size.height * .1,
              ),
              Image(
                image: const AssetImage(
                    "assets/images/virtuous_circle_outline.png"),
                height: 100,
              ),
              const Text(
                'Your journey starts with just one entry',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),
              ),
              const SizedBox(height: 20.0),
              Form(
                key: formGlobalKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (!RegExp(
                                  r'^[\w\.-]+@[\w-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(email ?? '')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: fullName,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.black,
                          ),
                        ),
                        validator: (fullName) {
                          if ((fullName ?? '').length < 3) {
                            return 'Name should be at least 3 characters';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.fingerprint_outlined,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: validatePassword,
                        validator: (password) {
                          if (!RegExp(
                                  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$')
                              .hasMatch(password ?? '')) {
                            return 'Please enter a stronger password';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPasswordRequirement(
                              'At least 8 characters', hasMinLength),
                          SizedBox(height: spacing),
                          buildPasswordRequirement(
                              'At least one uppercase letter', hasUpperCase),
                          SizedBox(height: spacing),
                          buildPasswordRequirement(
                              'At least one lowercase letter', hasLowerCase),
                          SizedBox(height: spacing),
                          buildPasswordRequirement(
                              'At least one number', hasNumber),
                          SizedBox(height: spacing),
                          buildPasswordRequirement(
                              'At least one special character (!@#\$&*~)',
                              hasSpecialChar),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: FormField<bool>(
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        activeColor: Color(0xFFC5B898),
                                        checkColor: Colors.white,
                                        onChanged: (bool? value) {
                                          checkboxNotifier.state = value ?? false;
                                          state.didChange(value);
                                        },           
                                      ),
                                      Expanded(
                                        child: RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            text: "I have read and agree to our ",
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Terms of Service ",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  ),

                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    // open Terms of Service Dialog
                                                    showDialog(context: context, builder: (context) {
                                                      return LegalDialog(mdFileName: 'terms_of_service.md');
                                                    },
                                                    );
                                                  },
                                              ),
                                              TextSpan( text: "and "),
                                              TextSpan(
                                                text: "Privacy Policy",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  ),

                                                  recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    // open Priacy Policy Dialog
                                                    showDialog(context: context, builder: (context) {
                                                      return LegalDialog(mdFileName: 'privacy_policy.md');
                                                    },
                                                    );
                                                  },
                                              ),
                                              TextSpan( text: "."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                ),
                                Row(
                                  children: [
                                    if (state.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Text(
                                          state.errorText ?? '',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.error,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                ],
                              )
                            ],
                          );
                        },
                        validator: (value) {
                          if (checkboxNotifier.state == false) { 
                            return 'Please accept our Terms to create an account';
                          } else {
                            return null;
                          }
                        },
                      ),
                  ),
                ],
              )),
              SizedBox(height: 20.0), //20
              // Sign Up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: const Color(0xFFC5B898),
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    shadowColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (formGlobalKey.currentState!.validate()) {
                      ref.read(authControllerProvider.notifier).createAccount(
                          email.text, password.text, fullName.text);
                      ref.invalidate(authControllerProvider);
                    } else {
                      showToasty('Please correct the errors', false);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => GoRouter.of(context).go('/signIn'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
