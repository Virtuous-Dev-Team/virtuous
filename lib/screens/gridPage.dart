import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class GridPage extends StatelessWidget {
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
              borderRadius: const BorderRadius.all(Radius.circular(20),),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text('Which virtue did you use today?',
                  style: GoogleFonts.tinos(textStyle: TextStyle(
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
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),

                            // Honesty Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Honesty',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFF3A3CA),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(width: 20),

                            // Courage Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Courage',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFC1D9CD),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),

                            SizedBox(width: 20),

                            // Compassion Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Compassion',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFB0E5F6),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),

                        // second row
                        Row(
                          children: [
                            SizedBox(width: 10),

                            // Generosity Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Generosity',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFF6EEA2),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(width: 20),

                            // Fidelity Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Fidelity',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFC58686),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),

                            SizedBox(width: 20),

                            // Integrity Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Compassion',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFFADAB4),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40,),
                        // third row
                        Row(
                          children: [
                            SizedBox(width: 10),

                            // Fairness Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Fairness',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFFDEBFF5),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(width: 20),

                            // Self-Control Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Self-Control',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFF7AB0D8),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),

                            SizedBox(width: 20),

                            // Prudence Button
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Prudence',
                                  style: GoogleFonts.tinos(textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Color(0xFF7FA881),
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}