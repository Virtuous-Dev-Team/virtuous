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
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
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
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
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
