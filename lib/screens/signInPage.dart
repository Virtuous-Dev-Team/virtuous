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
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // logo
                Image(
                  image:
                  const AssetImage("assets/images/virtuous_circle_outline.png"),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                // password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                          'Forgot Password?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              color: Colors.black)
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // sign in button
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFFC1D9CD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OutlinedButton(
                    onPressed: () {  },
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
                SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.black),
                          ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // Sign In Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset("assets/images/googleLogo.png",
                        height: 30,),
                    ),

                    SizedBox(width: 25),

                    // Apple Button
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset("assets/images/appleLogo.png",
                        height: 30,),
                    ),

                    SizedBox(width: 25),

                    // Facebook Button
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset("assets/images/facebookLogo.png",
                        height: 30,),
                    ),
                  ],
                ),

                // dont have an account?
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black) ),
                    TextButton(
                      child: Text('Sign Up',
                          style: TextStyle(decoration: TextDecoration.underline, fontStyle: FontStyle.italic, color: Colors.black)),
                      onPressed: () {
                        // Redirect to Sign Up page
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