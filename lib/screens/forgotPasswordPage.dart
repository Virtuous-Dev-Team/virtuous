import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

ToastNotificationWidget toast = ToastNotificationWidget();

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();
  String errorMessage = '';
  final formGlobalKey = GlobalKey<FormState>();
  void showToasty(msg, bool success, BuildContext context1) {
    print('calling toast widget on sign forgot pASSOWRD');
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ToastNotificationWidget().successOrError(
        context1,
        msg,
        success,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(authControllerProvider).when(
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) {
              Future.delayed(Duration.zero, () {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  // ref.read(authControllerProvider.notifier).state =
                  //     AsyncLoading();
                  if (mounted) {
                    // Check if the widget is mounted
                    dynamic errorType = error;
                    if (errorType['Function'] == 'forgotPassword') {
                      showToasty(errorType['msg'], false, context);
                    }
                  }
                });
              });
            },
            data: (response) async {
              print("What is the response in sign in: $response");
              if (response is bool && response == true) {
                showToasty('Password reset email sent', true, context);

                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  GoRouter.of(context).go('/signIn');
                });
              }
            },
          );
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
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'We will send a password reset link',
                    style: GoogleFonts.tinos(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                // Email input field
                Form(
                    key: formGlobalKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: email,
                        validator: validateEmail,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.black),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    )),

                SizedBox(height: 10.0),
                SizedBox(height: 20.0),
                // Reset Password button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Color(0xFFC1D9CD),
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .forgotPassword(email.text);
                        ref.invalidate(authControllerProvider);
                        // Clear the error message when passwords match
                        setState(() {
                          errorMessage = '';
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Display error message
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

String? validateEmail(String? email) {
  RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailRegex.hasMatch(email ?? '');
  if (!isEmailValid) {
    return 'Please enter a valid email';
  }
  return null;
}
