// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

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
        // user is authenticated in firebase authenctication
        // send to SignInPage
        // ref.read(AppNavigation.router).go('/signIn');
        return {
          'Success': result['Success'],
          'msg': "Account created successfully"
        };
      } else {
        print('Error ${result}');

        return {'Success': result['Success'], 'msg': result['Error']};
      }
    } else {
      // Show user error and remind them to fill out fields.
    }
  } catch (error) {
    print(error);
  }
}

class SignUpPage extends ConsumerWidget {
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();

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

  ToastNotificationWidget toast = ToastNotificationWidget();
  void showToasty(msg, success, context) {
    print('calling toast widget in sign up page');
    toast.successOrError(context, msg, success);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ToastNotificationWidget toast = ToastNotificationWidget();
    void showToasty(msg, success, context2) {
      print('calling toast widget in sign up page');
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ToastNotificationWidget().successOrError(
          context,
          msg,
          success,
        );
      });
    }

    final formGlobalKey = GlobalKey<FormState>();
    ref.watch(authControllerProvider).when(
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) {
          Future.delayed(Duration.zero, () {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              // ref.read(authControllerProvider.notifier).state = AsyncLoading();
              dynamic errorType = error;
              if (errorType['Function'] == 'createAccount')
                showToasty(errorType['msg'], false, context);
            });
          });
        },
        data: (response) {
          print('going to sign in page, after signing out ');
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            GoRouter.of(context).go(response);
          });
        });
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFDF9),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50),
              Image(
                image: const AssetImage(
                    "assets/images/virtuous_circle_outline.png"),
                height: 100,
              ),
              Text(
                'Your journey starts with just one entry',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),
              ),
              SizedBox(height: 20.0),
              Form(
                  key: formGlobalKey,
                  child: Column(
                    children: [
// Email input field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Full Name input field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: fullName,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.black,
                            ),
                          ),
                          validator: (fullName) => fullName!.length < 3
                              ? 'Name should be at least 3 characters'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Password input field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      SizedBox(height: 10.0),
                    ],
                  )),

              SizedBox(height: 20.0),
              // Sign Up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: Color(0xFFC5B898),
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    shadowColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (formGlobalKey.currentState!.validate()) {
                      print('Fields pass validation');
                      try {
                        // Redirect to Survey or Verify Email page after calling function
                        ref.read(authControllerProvider.notifier).createAccount(
                            email.text, password.text, fullName.text);
                        ref.invalidate(authControllerProvider);
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      print('Fields not passing validation');
                    }
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                  TextButton(
                    child: const Text('Sign In',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    onPressed: () {
                      // Redirect to Sign In page
                      GoRouter.of(context).go('/signIn');
                    },
                  ),
                ],
              ),

              SizedBox(height: 130),
              Text(
                'We Value Your Privacy\nBy signing up, you agree to our Terms and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
