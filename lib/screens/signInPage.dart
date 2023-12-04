// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

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
            // FlutterLogo(size: 100.0), // Placeholder for the logo
            Image(
              image:
                  const AssetImage("assets/images/virtuous_circle_outline.png"),
              height: 100,
            ),
            //  SizedBox(height: 20.0),
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
                elevation: 0,
                backgroundColor: Color(0xFFC1D9CD),
                side: BorderSide(color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 30.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                // Handle Sign In
                callAuthSignIn(email, password);
              },
            ),
            SizedBox(height: 5),
            TextButton(
              child: Text('Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                      color: Colors.black)),
              onPressed: () {
                // Handle Forgot Password
              },
            ),
            SizedBox(height: 30.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF272727),
                side: BorderSide(color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 28.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                // Handle Google Sign In
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.5, 0),
                    child: Image(
                      image: const AssetImage("assets/images/googleLogo.png"),
                      height: 17,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.05, 0),
                    child: Text('Continue with Google',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF272727),
                side: BorderSide(color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 28.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                // Handle Facebook Sign In
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.5, 0),
                    child: Image(
                      image: const AssetImage("assets/images/appleLogo.png"),
                      height: 17,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.06, 0),
                    child: Text('Continue with Apple',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF272727),
                side: BorderSide(color: Colors.black87),
                padding: EdgeInsets.symmetric(vertical: 28.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                // Handle Facebook Sign In
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.5, 0),
                    child: Image(
                      image: const AssetImage("assets/images/facebookLogo.png"),
                      height: 17,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.02, 0),
                    child: Text('Continue with Facebook',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
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
