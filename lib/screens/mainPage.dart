import 'package:flutter/material.dart';
import 'package:virtuetracker/screens/navBarPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    NavBarPage(),
    AnalysisPage(),
    ResourcePage()
  ];
  int currentIndex = 0; // used to keep track of which page is currently displayed
  void onTap(int index){
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
        backgroundColor: Colors.purple,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Nearby'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Resources'),
        ],
      ),
    );
  }
}
