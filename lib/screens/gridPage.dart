import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

final List<int> quadrantColors = [
  0xFFF3A3CA,
  0XFFCBF1D1,
  0XFFB0E5F6,
  0XFFF6EEA2,
  0XFFC58686,
  0XFFFADAB4,
  0XFFDEBFF5,
  0XFF7AB0D8,
  0XFF7FA881,
];

final List<String> quadrantNames = [
  'Honesty',
  'Courage',
  'Compassion',
  'Generosity',
  'Fidelity',
  'Integrity',
  'Fairness',
  'Self-control',
  'Prudence',
];

// Example 1 on how to use Stateful widgets to load data from api call

// class GridPagey extends StatefulWidget {
//   final String appBarChoice;

//   const GridPagey({super.key, required this.appBarChoice});

//   @override
//   State<GridPagey> createState() => _GridPageyState(appBarChoice: appBarChoice);
// }

// class _GridPageyState extends State<GridPagey> {
//   List<dynamic>? quadrantList = [];
//   final String appBarChoice;

//   _GridPageyState({required this.appBarChoice});

//   @override
//   void initState() {
//     super.initState();
//     callGetQuadrantList();
//   }

//   Future<dynamic> callGetQuadrantList() async {
//     final Communities communities = Communities();

//     try {
//       dynamic result = await communities.getQuadrantList("legal");
//       if (result['Success']) {
//         // user is authenticated in firebase authenctication
//         // send to homepage
//         setState(() {
//           quadrantList = result['response'];
//         });
//       } else {
//         print(result['Error']);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(quadrantList);
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xFFEFE5CC),
//         appBar: AppBarWidget(appBarChoice),
//         body: Stack(
//           children: <Widget>[
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               height: 740,
//               child: Container(
//                 color: Color(0xFFFFFDF9),
//               ),
//             ),
//             Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Text(
//                   'Which virtue did you use today?',
//                   style: GoogleFonts.tinos(
//                     textStyle: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Divider(
//                   thickness: 0.5,
//                   color: Colors.black,
//                   indent: 30,
//                   endIndent: 30,
//                 ),
//                 Expanded(
//                     child: Container(
//                   // child: BuildGrid(listy: quadrantList),
//                   padding: EdgeInsets.only(left: 15, right: 15, top: 20),
//                 ))
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class GridPagey extends ConsumerWidget {
  final String appBarChoice;

  const GridPagey({super.key, required this.appBarChoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(communitiesControllerProvider((communityName: "legal")));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
        appBar: AppBarWidget(appBarChoice),
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
                Expanded(
                    child: Container(
                  child: controller.when(
                    loading: () => CircularProgressIndicator(),
                    error: (error, stackTrace) => Text('Error: $error'),
                    data: (quadrantList) => BuildGrid(
                      listy: quadrantList,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuildGrid extends StatelessWidget {
  final List<dynamic>? listy;

  const BuildGrid({Key? key, this.listy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(listy);
    return (listy ?? []).isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              final Map<String, dynamic> item =
                  listy![index] as Map<String, dynamic>;
              return Rectangle(
                quadrantName: item['quadrantName'],
                quadrantColor:
                    int.tryParse(item['quadrantColor'].toString()) ?? 0,
                quadrantDefinition: item['quadrantDefinition'],
              );
            },
            itemCount: listy!.length,
          );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle(
      {super.key,
      required this.quadrantName,
      required this.quadrantColor,
      required this.quadrantDefinition});

  final String quadrantName;
  final int quadrantColor;
  final String quadrantDefinition;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Maintain a 1:1 aspect ratio (adjust as needed)
      child: Container(
        width: 100.0, // Set a fixed width for the button
        child: ElevatedButton(
          onPressed: () {
            // ADD ME!!!
            GoRouter.of(context).goNamed('VirtueEntryPage', pathParameters: {
              'quadrantName': quadrantName,
              'quadrantDefinition': quadrantDefinition,
              'quadrantColor': quadrantColor.toString(),
            });
          },
          child: FractionallySizedBox(
            widthFactor: 2,
            child: Center(
              child: Text(
                quadrantName,
                maxLines: 1,
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
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
    );
  }
}
