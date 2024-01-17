import 'package:flutter/material.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';

// void getUserInfo

class NavControllerPage extends StatefulWidget {
  const NavControllerPage({super.key});

  @override
  State<NavControllerPage> createState() => _NavControllerPageState();
}

class _NavControllerPageState extends State<NavControllerPage> {
  List pages = [HomePage(), AnalysisPage(), NearbyPage(), ResourcePage()];
  int currentIndex =
      0; // used to keep track of which page is currently displayed
  void onTap(int index) {
    setState(() {
      currentIndex = index; // sets the currentIndex
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff9C98C5),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.near_me), label: 'Nearby'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'Resources'),
        ],
      ),
    );
  }
}
