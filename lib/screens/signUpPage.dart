import 'package:flutter/material.dart';

void main() {
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

class SignUpPage extends StatelessWidget {
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 10.0),
            // Phone Number input field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
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
                // Handle Sign Up
              },
            ),
            SizedBox(height: 10.0),
            TextButton(
              child: Text('Already have an account? Sign In',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                // Redirect to Sign In page
              },
            ),
          ],
        ),
      ),
    );
  }
}
