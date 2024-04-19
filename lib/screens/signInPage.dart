import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

final Auth auth = Auth();
final Users users = Users();
ToastNotificationWidget toast = ToastNotificationWidget();

Future<dynamic> callAuthSignIn(email, password, context, ref) async {
  String emailInput = email.text;
  String passwordInput = password.text;

  try {
    // If fields are filled out, try and create user in firebase authentications
    if (emailInput.isNotEmpty && passwordInput.isNotEmpty) {
      dynamic result = await auth.signInUser(emailInput, passwordInput);
      if (result['Success']) {
        // user is authenticated in firebase authenctication
        // send to homepage
        // Navigator.pushReplacement(
        //   context,
        //   CupertinoPageRoute(builder: (context) => HomePage()),
        // );
        return {'Success': result['Success'], 'msg': "Successful sign in"};
        // final authService = context.read(authRepositoryProvider);
        // ref.read(AppNavigation.router).go('/home');
      } else {
        return {'Success': result['Success'], 'msg': result['Error']};
      }
    }
    // If fields are empty
    else {
      // Show user error and remind them to fill out fields.
    }
  } catch (error) {
    // Error message is inside of error.
    // Message: The supplied auth credential is incorrect

    print(error);
  }
}

Future<dynamic> getUserInfo(ref) async {
  // final info = await ref.watch(currentUserInfo);
  final info = await users.getUserInfo();

  print('info in sign in page $info');
  return info;
}

class SignInPage extends ConsumerWidget {
  TextEditingController email = TextEditingController();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authControllerProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            Future.delayed(Duration.zero, () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // ref.read(authControllerProvider.notifier).state =
                //     AsyncLoading();
                dynamic errorType = error;
                if (errorType['Function'] == 'signIn') {
                  showToasty(errorType['msg'], false, context);
                }
              });
            });
          },
          data: (response) async {
            print("What is the response in sign in: $response");
            await setUserInfoProvider(ref);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(context).go(response);
            });
          },
        );

    final formGlobalKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF9),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .1,
              ),
              // logo
              Image(
                image: const AssetImage(
                    "assets/images/virtuous_circle_outline.png"),
                height: 100,
              ),
              // slogan
              Text(
                'Reflect, Choose, Grow',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25.0),
              ),
              SizedBox(height: 5.0),
              Text(
                'Log your daily virtues and transform your life',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16.0),
              ),

              SizedBox(height: 20.0),

              // username textfield
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
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
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
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
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
                    BoxShadow(
                        color: Colors.grey, blurRadius: 4, offset: Offset(1, 2))
                  ],
                ),
                child: OutlinedButton(
                  onPressed: () async {
                    // if (formGlobalKey.currentState!.validate()) {
                    print('Fields pass validation');
                    try {
                      final authController =
                          ref.read(authControllerProvider.notifier);

                      await authController.signIn(email.text, password.text);
                      ref.invalidate(authControllerProvider);
                    } catch (e) {
                      print('Error in sig in btn container $e');
                    }
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

              const SizedBox(height: 15),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go('/signIn/forgotPassword');
                      },
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50),

              // or continue with
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.black,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Text(
              //           'Or continue with',
              //           style: TextStyle(color: Colors.black),
              //         ),
              //       ),
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(height: 15),

              // // Sign In Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // Google Button
              //     GestureDetector(
              //         onTap: () => Auth().signInWithGoogle(),
              //         child: Container(
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.black),
              //             borderRadius: BorderRadius.circular(16),
              //           ),
              //           child: Image.asset(
              //             "assets/images/googleLogo.png",
              //             height: 20,
              //           ),
              //         )),

              //     SizedBox(width: 45),

              //     // Apple Button
              //     GestureDetector(
              //       onTap: () {},
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.black),
              //             borderRadius: BorderRadius.circular(16),
              //           ),
              //           child: Image.asset(
              //             "assets/images/appleLogo.png",
              //             height: 20,
              //           ),
              //         ),
              //       ),
              //     ),

              //     SizedBox(width: 45),

              //     // Facebook Button
              //     GestureDetector(
              //       onTap: () => Auth().signInWithFacebook(),
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.black),
              //             borderRadius: BorderRadius.circular(16),
              //           ),
              //           child: Image.asset(
              //             "assets/images/facebookLogo.png",
              //             height: 20,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // dont have an account?

              SizedBox(height: 120.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black)),
                  TextButton(
                    child: Text('Sign Up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                    onPressed: () {
                      GoRouter.of(context).go('/signIn/signUp');
                    },
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
