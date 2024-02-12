import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/communities.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

final List<int> quadrantColors = [
  0xFFF3A3CA, 0XFFCBF1D1, 0XFFB0E5F6, 0XFFF6EEA2, 0XFFC58686, 0XFFFADAB4, 0XFFDEBFF5, 0XFF7AB0D8, 0XFF7FA881,
];

final List<String> quadrantNames = [
  'Honesty', 'Courage', 'Compassion', 'Generosity', 'Fidelity', 'Integrity', 'Fairness', 'Self-control', 'Prudence',
];

Future<dynamic> callGetQuadrantList() async {
  final Communities communities = Communities();

  try {
    dynamic result = await communities.getQuadrantList();
    if (result['Success']) {
      // user is authenticated in firebase authenctication
      // send to homepage
    } else {
      print(result['Error']);
    }
  } catch (e) {
    print(e);
  }
}

class GridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quadrantList = callGetQuadrantList();
    print(quadrantList);
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
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              height: 680, //740
              child: Container(
                color: Color(0xFFFFFDF9),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 50,),
                Text('Which virtue did you use today?',
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Adjust the number of columns here!!!
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 25,
                  ),
                  itemCount: 9, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return Rectangle(
                      quadrantName: quadrantNames[index],
                      quadrantColor: quadrantColors[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Integrity Button Rectangle(quadrantName: 'Integrity', quadrantColor: '0xFFFADAB4')
/* child: ListView.builder(itemCount: 1, itemBuilder: (BuildContext context, int index)
                        {
                          return Container(child:Rectangle(quadrantName: 'Integrity', quadrantColor: 0xFFFADAB4) ,);
                        }
                        */
class Rectangle extends StatelessWidget {
  const Rectangle({super.key, required this.quadrantName, required this.quadrantColor});

  final String quadrantName;
  final int quadrantColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Maintain a 1:1 aspect ratio (adjust as needed)
      child: Container(
        child: Container(
          width: 100.0, // Set a fixed width for the button
          child: ElevatedButton(
            onPressed: () {
              // ADD ME!!!
            },
            child: FractionallySizedBox(
              widthFactor: 2,
              child: Center(
                child: Text(
                  quadrantName,
                  maxLines: 1,
                  style: GoogleFonts.tinos(textStyle: TextStyle(
                    color: Colors.black,),
                  ),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(quadrantColor),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ),
    );
  }
}
