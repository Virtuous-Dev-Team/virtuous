// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtuetracker/screens/signInPage.dart';

void callAuthCreateAccount(email, password, fullName, context) async {
  final Auth auth = Auth();
  String emailInput = email.text;
  String fullNameInput = fullName.text;
  String passwordInput = password.text;

  try {
    if (emailInput.isNotEmpty &&
        fullNameInput.isNotEmpty &&
        passwordInput.isNotEmpty) {
      dynamic result =
          await auth.createAccount(emailInput, passwordInput, fullNameInput);
      if (result['Success']) {
        // user is authenticated in firebase authenctication
        // send to SignInPage
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        print(result["Error"]);
      }
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

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDF9),
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
              // Email input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.black),
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
                        fontStyle: FontStyle.italic, color: Colors.black),
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
                child: TextField(
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
                  onPressed: () {
                    // Redirect to Survey or Verify Email page after calling function
                    callAuthCreateAccount(email, password, fullName, context);
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
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => SignInPage()),
                      );
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
