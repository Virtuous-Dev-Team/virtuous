
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/apptheme.dart';
import 'package:virtuetracker/controllers/resourcesController.dart';

//import '../widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: ResourcePage(),
    );
  }
}

class ResourcePage extends StatefulWidget {
  const ResourcePage({Key? key}) : super(key: key);

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ref, _) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: Color(0xFFEFE5CC),
              //appBar: AppBarWidget('regular'),
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
              body: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF9),
                    border:
                    Border.all(color: const Color(0xFFFEFE5CC), width: 9.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colours.swatch(clrBackground),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          onTap: (index) {
                            print('tapped $index');
                            if (index == 1) {
                              ref
                                  .read(resourcesControllerProvider.notifier)
                                  .getResources("legal");
                            }
                          },
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Colours.black),
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: Colours.swatch(clrBlack),
                          indicatorPadding:
                          const EdgeInsets.only(left: 0, right: 0),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Colours.swatch(clrWhite),
                          ),
                          indicatorColor: Colours.swatch(clrBlack),
                          tabs: const [
                            Tab(
                              text: "Vitruous",
                            ),
                            Tab(
                              text: "My Community",
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Vitruous(screenWidth, screenHeight),
                            MyCommunity(screenWidth, screenHeight)

                            // ClientScreen(widget.clientsResponseData!,widget.authentication!,session.tokens!,widget.index!),
                            // // ClientScreen(widget.clientsResponseData!,widget.authentication!,widget.token!,widget.index!),
                            // SignatureScreen(widget.clientsResponseData!,widget.authentication!,session.tokens!,widget.index!,_scaffoldKey),
                            //
                          ],
                        ),
                      )
                    ],
                  ))));
    });
  }

  Widget Vitruous(double screnWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Container(
        color: Colours.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight / 60),
              child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colours.swatch("#FAD4E3")),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Why use virtues?",
                        style: GoogleFonts.tinos(
                          textStyle: TextStyle(),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colours.swatch(clrBlack),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight / 60),
              child: Container(
                // width: screnWidth/3,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     color: Colours.swatch("#FAD4E3")
                  // ),
                  child: Center(
                    child: Text(
                        "Using virtues can have a positive impact on one’s mental state. Focusing on the positive aspects of life greatly increases one’s outlook and mood. and stuff",
                        style: GoogleFonts.tinos(
                          textStyle: TextStyle(),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colours.swatch(clrBlack),
                        )),
                  )),
            )
          ],
        ),
      ),
    );
    ;
  }

  Widget MyCommunity(double screnWidth, double screenHeight) {
    final List<String> virtues = [
      "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
      "Courage is the willingness to face fear, danger, or challenges with bravery and determination.",
      "Compassion is caring for others and wanting to help them when they are going through difficult times.",
      "Generosity is the act of giving or sharing with others, often without expecting anything in return.",
      "Fairness is treating people justly, not letting your personal feelings bias your decisions about others.",
      "Integrity is the practice of being honest and showing a consistent and uncompromising adherence to strong moral and ethical principles and values.",
      "Fidelity is faithfulness, loyalty, and the commitment to keeping promises and maintaining trust in a relationship or duty."
    ];
    // String? communityDescription;
    // List<String>? listy = [];
    return Consumer(builder: (context, ref, _) {
      ref.watch(resourcesControllerProvider).when(
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) {
          // Future.delayed(Duration.zero, () {
          //   showToasty(error.toString(), false, context);
          // });
        },
        data: (response) async {
          print("Getting resource List: $response");
          // listy = response['quadrantInfoList'];
          // communityDescription = response['communityDescription'];
        },
      );
      return SingleChildScrollView(
        child: Container(
          color: Colours.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 60),
                    child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: screnWidth),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colours.swatch("#D7F1F7")),
                      child: Center(
                        child: Align(
                            alignment: Alignment.center, // Align text to the left
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Why are virtues important \n       in my community?",
                              style: GoogleFonts.tinos(
                                textStyle: TextStyle(),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colours.swatch(clrBlack),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 60),
                    child: Container(
                      // width: screnWidth/3,
                        constraints: BoxConstraints(maxWidth: screnWidth),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     color: Colours.swatch("#FAD4E3")
                        // ),
                        child: Center(
                          child: Text("The legal community has seen an increase in\n"
                              "corruption. Using virtues ensures that those\n"
                              "who practice law use their knowledge for\n"
                              "noble purposes.",
                              style: GoogleFonts.tinos(
                                textStyle: TextStyle(),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colours.swatch(clrBlack),
                              )),
                        )),
                  ),
                ],
              ),
              Divider(
                endIndent: 10,
                indent: 10,
                color: Colours.swatch(clrBlack),
                height: screenHeight / 35,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 60),
                    child: Container(
                      width: screnWidth / 2.3,
                      constraints: BoxConstraints(maxWidth: screnWidth),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colours.swatch("#DEBFF5")),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("About my virtues:",
                            style: GoogleFonts.tinos(
                              textStyle: TextStyle(),
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colours.swatch(clrBlack),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "\u2022 Honesty is being truthful and sincere in both words and actions, without deceit or deception.\n"
                    "\u2022 Courage is the willingness to face fear, danger, or challenges with bravery and determination.\n"
                    "\u2022 Compassion is caring for others and wanting to help them when they are going through difficult times.\n"
                    "\u2022 Generosity is the act of giving or sharing with others, often without expecting anything in return.\n"
                    "\u2022 Fairness is treating people justly, not letting your personal feelings bias your decisions about others.\n"
                    "\u2022 Integrity is the practice of being honest and showing a consistent and uncompromising adherence to strong moral and ethical principles and values.\n"
                    "\u2022 Fidelity is faithfulness, loyalty, and the commitment to keeping promises and maintaining trust in a relationship or duty.\n",
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colours.swatch(clrBlack),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
  }
}
