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

Future<dynamic> callGetQuadrantList() async {
  final Communities communities = Communities();

  // try {
  //   dynamic result = await communities.getQuadrantList();
  //   if (result['Success']) {
  //     // user is authenticated in firebase authenctication
  //     // send to homepage
  //   } else {
  //     print(result['Error']);
  //   }
  // } catch (e) {
  //   print(e);
  // }
}

class GridPage2 extends StatelessWidget {
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
              height: 740,
              child: Container(
                color: Color(0xFFFFFDF9),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Which virtue did you use today?',
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: GridView.count(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 3,
                  children: [
                    Rectangle(
                        quadrantName: 'Honesty', quadrantColor: 0xFFF3A3CA),
                    Rectangle(
                        quadrantName: 'Courage', quadrantColor: 0XFFCBF1D1),
                    Rectangle(
                        quadrantName: 'Compassion', quadrantColor: 0XFFB0E5F6),
                    Rectangle(
                        quadrantName: 'Generosity', quadrantColor: 0XFFF6EEA2),
                    Rectangle(
                        quadrantName: 'Fidelity', quadrantColor: 0XFFC58686),
                    Rectangle(
                        quadrantName: 'Integrity', quadrantColor: 0XFFFADAB4),
                    Rectangle(
                        quadrantName: 'Fairness', quadrantColor: 0XFFFADAB4),
                    Rectangle(
                        quadrantName: 'Self-control',
                        quadrantColor: 0XFF7AB0D8),
                    Rectangle(
                        quadrantName: 'Prudence', quadrantColor: 0XFF7FA881),
                  ],
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
  const Rectangle(
      {super.key, required this.quadrantName, required this.quadrantColor});

  final String quadrantName;
  final int quadrantColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: ElevatedButton(
            child: Text(
              //'WOOW',
              quadrantName,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Color(quadrantColor),
              // padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
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

/*
body: Center(
            child: Container(
              /*
              decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              ),

              padding: const EdgeInsets.all(10.0),
               */
          child: Column(
            children: [
              /*
              SizedBox(height: 40),
              Text(
                'Which virtue did you use today?',
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
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(height: 40),

               */
              Container(
                child: Center(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      ),
                      itemCount: 9,
                          itemBuilder: (BuildContext context, int index){
                            return Rectangle(
                                quadrantName: 'Integrity', quadrantColor: 0xFFFADAB4);

                          },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
 */