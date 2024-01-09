import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class GridPage2 extends StatelessWidget {
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
          // Integrity Button Rectangle(quadrantName: 'Integrity', quadrantColor: '0xFFFADAB4')
                   child: ListView.builder(itemCount: 1, itemBuilder: (BuildContext context, int index){return Container(child:Rectangle(quadrantName: 'Integrity', quadrantColor: 0xFFFADAB4) ,);})
    ),
      ),
    );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle({super.key, required this.quadrantName, required this.quadrantColor});

  final String quadrantName;
  final int quadrantColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      child: Center(
        child: Expanded(
          child: ElevatedButton(
            child: Text(
              quadrantName,
              style: GoogleFonts.tinos(textStyle: TextStyle(
                fontSize: 13,
                color: Colors.black,),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Color(quadrantColor),
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              shadowColor: Colors.black,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
