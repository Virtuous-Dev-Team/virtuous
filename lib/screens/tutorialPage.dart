// Path: lib/pages/tutorial_page.dart
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:virtuetracker/screens/homePage.dart';
//import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.black; // Black text color for content
TextEditingController tfDescription = TextEditingController();
List<ButtonsData>? GridviewData = [
  ButtonsData(color: "#F3A3CA", text: "Honesty"),
  ButtonsData(color: "#C1D9CD", text: "Courage"),
  ButtonsData(color: "#B0E5F6", text: "Compassion"),
  ButtonsData(color: "#F6EEA2", text: "Generosity"),
  ButtonsData(color: "#C58686", text: "Fidelity"),
  ButtonsData(color: "#FADAB4", text: "Integrity"),
  ButtonsData(color: "#DEBFF5", text: "Fairness"),
  ButtonsData(color: "#7AB0D8", text: "Self-control"),
  ButtonsData(color: "#7FA881", text: "Prodence")
];

void main() => runApp(MaterialApp(home: TutorialPage()));

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: mainBackgroundColor,
        //appBar: AppBarWidget('Tutorial'),             UNCOMMENT
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
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildTutorialScreen1(
                        title: 'Getting Started',
                        content:
                            'Welcome to Virtuous! This is the home page. Let’s have you practice adding an entry. '
                            'Select the “Reflect” button below to add a virtue entry to your account. '
                            'This page also shows you all of your entries for the current date.',
                        backgroundColor: Color(0xFFFFEEDB),
                      ),
                      buildTutorialScreen2(
                        title: 'Getting Started',
                        content:
                            'Now select one of the virtues below that you feel you used today. '
                            'You may make multiple entries in a day, so just choose one for now.',
                        backgroundColor: Color(0xFFF2E1F8),
                      ),
                      buildTutorialScreen3(
                        title: 'Getting Started',
                        content:
                            'Great choice. Now answer the prompts to the best of your ability. '
                            'We want you to focus on the positive aspects of these experiences- '
                            'how did you grow or improve as a person?',
                        backgroundColor: Color(0xFFC0DDEB),
                      ),
                      buildTutorialScreen4(),
                      buildTutorialScreen5(
                        title: 'Getting Started',
                        content:
                            'Now you’re ready to use Virtuous to it’s fullest potential and become the best version of yourself. Good luck!',
                        backgroundColor: Color(0xFFF2E1F8),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 5,
                    effect: WormEffect(
                      dotColor: Colours.swatch("#EFE5CC"),
                      activeDotColor: Colours.swatch("#C5B898"),
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
// Bottom navigation bar code would be here
      ),
    );
  }

  Widget buildTutorialScreen1(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Center(
            child: Text(
              'Getting started',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
          SizedBox(height: 20.0),
          MaterialButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colours.swatch('#c5b898'),
                  borderRadius: BorderRadius.circular(100)),
              width: 200,
              height: 200,
              child: Center(
                  child: Text(
                "Reflect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: iconColor,
                ),
              )),
            ),
          ),
// SizedBox(height: 10.0),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colours.swatch("#534D3F"),
            height: MediaQuery.of(context).size.height / 35,
          ),
          SizedBox(height: 40,),
          Text(
            "Select the button above to add an entry.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: Colours.swatch("#C5B898"),
            ),
          ),

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget buildTutorialScreen2(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Center(
            child: Text(
              'Getting started',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
          SizedBox(height: 50.0),
          GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(GridviewData!.length, (index) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colours.swatch(GridviewData![index].color),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(
                          GridviewData![index].text.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: iconColor,
                          ),
                        ))),
                  )
                ],
              );
            }),
          )

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget buildTutorialScreen3(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Center(
            child: Text(
              'Getting started',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Honesty",
            style: TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.normal,
              color: iconColor,
            ),
          ),
          SizedBox(height: 8.0),
/*  MaterialButton(onPressed: (){
            _pageController.nextPage(duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },child: Container(decoration: BoxDecoration(color: Colours.swatch('#c5b898'),borderRadius: BorderRadius.circular(100)),width: 200,height: 200,
            child: Center(child: Text("Reflect",style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: iconColor,
            ),)) ,
          ),),*/
// SizedBox(height: 10.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Center(
              child: Text(
                "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Colours.swatch("#888479"),
                ),
              ),
            ),
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colours.swatch("#F3A3CA"),
            height: MediaQuery.of(context).size.height / 35,
          ),
          Container(
            child: Text(
              "Describe how you used this virtue today.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colours.swatch("#000000"),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          textFieldNoteInput(context, tfDescription)

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget textFieldNoteInput(
      BuildContext context, TextEditingController controller) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        height: 120,
        child: TextFormField(
          cursorColor: Colors.black,
          cursorRadius: const Radius.circular(0),
          controller: controller,
          maxLines: 4,
          style: TextStyle(color: iconColor, fontSize: 16),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              fillColor: Colours.swatch("#ffffff")),
        ));
  }

  Widget buildTutorialScreen4() {
    return InkWell(
      onTap: () {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Image(
                  image: const AssetImage(
                      "assets/images/intro_virtue.png"),
                  fit: BoxFit.contain,
            ))

// Other widgets or content can go here
          ],
        ),
      ),
    );
  }

  Widget buildTutorialScreen5(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Center(
            child: Text(
              'Getting started',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
          SizedBox(height: 50.0),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colours.swatch('#bab7d4'),
                  borderRadius: BorderRadius.circular(10)),
              width: 210,
              height: 50,
              child: Center(
                  child: Text(
                "Continue to Virtuous",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: iconColor,
                ),
              )),
            ),
          ),

// Other widgets or content can go here
        ],
      ),
    );
  }
}

class ButtonsData {
  String? color;
  String? text;

  ButtonsData({this.color, this.text});
}
