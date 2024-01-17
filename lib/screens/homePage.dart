import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'package:virtuetracker/screens/signInPage.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
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
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Reflect button functionality.
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => GridPage()),
                    );
                  },
                  child: Text(
                    'Reflect',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    shape: CircleBorder(),
                    elevation: 4,
                    padding: EdgeInsets.all(70),
                  ),
                ),
                Text(' '),
                Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Color(0xFFF3A3CA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(' '),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Honesty",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.tinos(
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(' '),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavBar(
        //   currentIndex: 0,
        //   onTap: (index) {},
        // ),
      ),
    );
  }
}
