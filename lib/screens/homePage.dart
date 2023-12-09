import 'package:flutter/material.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primaryColor: appBarColor,
        scaffoldBackgroundColor: mainBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30, color: iconColor),
            onPressed: () {
              // TODO: Implement profile icon functionality.
            },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement Reflect button functionality.
            },
            child: Text(
              'Reflect',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              elevation: 4,
              padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomNavBarColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: iconColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, color: iconColor),
            label: 'Analyze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: iconColor),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books, color: iconColor),
            label: 'Resources',
          ),
        ],
        selectedItemColor: textColor,
        unselectedItemColor: textColor,
        showUnselectedLabels: true,
      ),
    );
  }
}
