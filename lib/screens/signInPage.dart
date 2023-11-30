// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      home: SignInPage(),
    );
  }
}

void callAuthSignIn(email, password) {
  final Auth auth = Auth();
  String emailInput = email.text;
  String passwordInput = password.text;
  try {
    // If fields are filled out, try and create user in firebase authentications
    if (emailInput.isNotEmpty && passwordInput.isNotEmpty) {
      auth
          .signInUser(emailInput, passwordInput)
          .then((response) => {
                // user is authenticated in firebase authenctication
                // send to homepage
                print("success")
              })
          .catchError((error) => {
                // you can show error in message to user
                print(error)
              });
    }
    // If fields are empty
    else {
      // Show user error and remind them to fill out fields.
    }
  } catch (e) {
    print(e);
  }
}

class SignInPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
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
            Text(
              'Reflect, Choose, Grow',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
            ),
            Text(
              '\nLog your daily virtues and transform your life',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Sign In',
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
                // Handle Sign In
                callAuthSignIn(email, password);
              },
            ),
            TextButton(
              child: Text('Forgot Password?',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black)),
              onPressed: () {
                // Handle Forgot Password
              },
            ),
            SizedBox(height: 10.0),
            OutlinedButton.icon(
              icon: Icon(Icons.android,
                  color: Colors.black), // Placeholder icon for Google
              label: Text('Continue with Google',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                backgroundColor: Color(0xFFFFFDF9),
              ),
              onPressed: () {
                // Handle Google Sign In
              },
            ),
            SizedBox(height: 5.0),
            OutlinedButton.icon(
              icon: Icon(Icons.apple,
                  color: Colors.black), // Placeholder icon for Apple
              label: Text('Continue with Apple',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                backgroundColor: Color(0xFFFFFDF9),
              ),
              onPressed: () {
                // Handle Apple Sign In
              },
            ),
            SizedBox(height: 20.0),
            TextButton(
              child: Text('Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                // Redirect to Sign Up page
              },
            ),
          ],
        ),
      ),
    );
  }
}
