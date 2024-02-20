import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/firebase_options.dart';
import 'package:flutter/cupertino.dart';

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
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
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
                  'Forgot Password?',
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              // Email input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: newPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.black),
                    prefixIcon: Icon(
                      Icons.fingerprint_outlined,
                      color: Colors.black,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 10.0),
              // Confirm Password input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.black),
                    prefixIcon: Icon(
                      Icons.fingerprint_outlined,
                      color: Colors.black,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(height: 20.0),
              // Sign Up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  child: Text(
                    'Change Password',
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
                  onPressed: () {
                    String newPasswordText = newPassword.text;
                    String confirmPasswordText = confirmPassword.text;

                    if (newPasswordText.isEmpty ||
                        confirmPasswordText.isEmpty) {
                      // Set error message if either field is empty
                      setState(() {
                        errorMessage = 'Please fill in both fields';
                      });
                      return;
                    }

                    if (newPasswordText != confirmPasswordText) {
                      // Set error message if passwords don't match
                      setState(() {
                        errorMessage = 'Passwords do not match';
                      });
                      return;
                    }

                    // Clear the error message when passwords match
                    setState(() {
                      errorMessage = '';
                    });
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
  }
}
