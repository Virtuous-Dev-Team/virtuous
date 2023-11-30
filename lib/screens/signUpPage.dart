// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/firebase_options.dart';

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
      home: SignUpPage(),
    );
  }
}

void callAuthCreateAccount(email, password, fullName) {
  final Auth auth = Auth();
  String emailInput = email.text;
  String fullNameInput = fullName.text;
  String passwordInput = password.text;

  try {
    if (emailInput.isNotEmpty &&
        fullNameInput.isNotEmpty &&
        passwordInput.isNotEmpty) {
      auth
          .createAccount(emailInput, passwordInput, fullNameInput)
          .then((response) => {
                // user has been created in authentication.
                print("success")
              })
          .catchError((error) => {
                // you can show error in message to user
                print(error)
              });
    } else {
      // Show user error and remind them to fill out fields.
    }
  } catch (error) {
    print(error);
  }
}

class SignUpPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlutterLogo(size: 100.0), // Placeholder for the logo
            SizedBox(height: 20.0),
            // Email input field
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10.0),
            // Full Name input field
            TextField(
              controller: fullName,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10.0),
            // Password input field
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 10.0),
            // // Phone Number input field
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Phone Number',
            //     labelStyle:
            //         TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            //     prefixIcon: Icon(Icons.phone),
            //   ),
            //   keyboardType: TextInputType.phone,
            // ),
            SizedBox(height: 20.0),
            // Sign Up button
            ElevatedButton(
              child: Text('Sign Up',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFC1D9CD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: () {
                // Redirect to Survey or Verify Email page after calling function
                callAuthCreateAccount(email, password, fullName);
              },
            ),
            SizedBox(height: 10.0),
            TextButton(
              child: Text('Already have an account? Sign In',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                // Redirect to SignIn page
              },
            ),
          ],
        ),
      ),
    );
  }
}
