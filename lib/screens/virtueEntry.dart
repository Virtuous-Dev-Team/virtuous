import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import '../App_Configuration/apptheme.dart';
import '../App_Configuration/globalfunctions.dart';
import '../widgets/appBarWidget.dart';
class VirtueEntry extends StatefulWidget {
  final String? quadrantName;
  final String? definition;
  final String? color;
  VirtueEntry(
  {super.key,
  required this.quadrantName,
  required this.definition,
  required this.color});
  List<Events> eventList= [Events('Tv', false),Events('In a Meeting', true),Events('Reading Emails', false),
    Events('Driving', false),Events('Eating', false),Events('Exercising', false),Events('Commuting', false),
    Events('Working', false),Events('Other', false)];
  List<Events> whoWereWithYouList= [Events('Pet', false),Events('Co-Workers', true),Events('Family', false),
    Events('No one', false),Events('Friends', false),Events('Other', false)];
  List<Events> locationList= [Events('Work', false),Events('Home', false),Events('Outdoors', false),
    Events('School', false),Events('Commuting', false),Events('Other', false)];
  List<String> sleepingHoursList = [
    '1',
    '2',
    '3',
    '4'
  ];
  String sleepingHours = '';
  // you can send this data from backend

  TextEditingController tfDate = TextEditingController();
  TextEditingController tfTime = TextEditingController();
  TextEditingController tfDescription = TextEditingController();
  TextEditingController tfAdvice = TextEditingController();
  @override
  _VirtueEntryState createState() => _VirtueEntryState();
}
   class _VirtueEntryState extends State<VirtueEntry> {

  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return
      SafeArea(
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
                        buildVirtueEntry1(context,screenWidth,screenHeight

                        ),
                        buildVirtueEntry2(context,screenWidth,screenHeight,
                          quadrantName: widget.quadrantName!,
                          definition:widget.definition!

                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
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
  Widget buildVirtueEntry1(
      BuildContext context,
      double screenWidth,
      double screenHeight,

      ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'What were you doing when you modeled this virtue?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              thickness: 0.5,
              color: Colours.swatch(clrHonesty),
              indent: 30,
              endIndent: 30,
            ),
            Text(
              'Date of occurance ${widget.tfDate.text}, ${widget.tfTime.text}',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      MaterialButton(onPressed: (){

          _selectTime(context, widget.tfTime);


      },child: Container(
        width:screenWidth/3,
        height: 20,
        decoration: BoxDecoration(border: Border.all(
          color: Colors.black, // Set border color here
          width: 1, // Set border width here
        ),
            borderRadius: BorderRadius.circular(5)),
        child: Center(child: Text(
          'Pick Time',
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),),
      )),

      MaterialButton(onPressed: (){

  _selecteDate(context, DateTime.now(), widget.tfDate);


      },child:Container(
        width:screenWidth/3,
        height: 20,
        decoration: BoxDecoration(border: Border.all(
          color: Colors.black, // Set border color here
          width: 1, // Set border width here
        ),
            borderRadius: BorderRadius.circular(5)),
        child: Center(child: Text(
          'Pick Date',
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),),
      ))
        ],
      ),

            Text(
              'What event was happening',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
        Wrap(
          spacing: 10, // Space between containers
          runSpacing: 10, // Space between rows
          children: List.generate(
            widget.eventList.length, // Number of containers, you can replace this with your dynamic data length
                (index) =>   MaterialButton(onPressed: (){
                  setState(() {
                    if(widget.eventList[index].isSelected==true) {
                      widget.eventList[index].isSelected != false;
                    }
                    else{
                      widget.eventList[index].isSelected != true;
                    }
                  });


                },child:Container(
                  width:screenWidth/3,
                  height: 20,
                  decoration: BoxDecoration(border: Border.all(
                    color: Colors.black, // Set border color here
                    width: 1, // Set border width here
                  ),
                      color: Colours.swatch(widget.eventList[index].isSelected!?clrPurple:clrWhite),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(child: Text(
                    widget.eventList[index].eventName.toString(),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),),
                )),
          ),
        ),

            Text(
              'Who were you with?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            Wrap(
              spacing: 10, // Space between containers
              runSpacing: 10, // Space between rows
              children: List.generate(
                widget.whoWereWithYouList.length, // Number of containers, you can replace this with your dynamic data length
                    (index) =>   MaterialButton(onPressed: (){
                      setState(() {
                        widget.whoWereWithYouList[index].isSelected!=!widget.whoWereWithYouList[index].isSelected!;
                        for(int checkCount=0;checkCount<widget.whoWereWithYouList.length;checkCount++)
                        {
                          if(widget.whoWereWithYouList[index].isSelected==true)
                          {
                            if(widget.whoWereWithYouList[index]!=widget.whoWereWithYouList[checkCount])
                            {
                              widget.whoWereWithYouList[checkCount].isSelected != false;
                            }
                          }
                        }

                      });


                    },child:Container(
                      width:screenWidth/3,
                      height: 20,
                      decoration: BoxDecoration(border: Border.all(
                        color: Colors.black, // Set border color here
                        width: 1, // Set border width here
                      ),
                          color: Colours.swatch(widget.whoWereWithYouList[index].isSelected!?clrPurple:clrWhite),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(
                        widget.whoWereWithYouList[index].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),),
                    )),
              ),
            ),

            Text(
              'Where were you?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            Wrap(
              spacing: 10, // Space between containers
              runSpacing: 10, // Space between rows
              children: List.generate(
                widget.locationList.length, // Number of containers, you can replace this with your dynamic data length
                    (index) =>   MaterialButton(onPressed: (){
                      setState(() {
                        widget.locationList[index].isSelected!=!widget.locationList[index].isSelected!;
                        for(int checkCount=0;checkCount<widget.locationList.length;checkCount++)
                        {
                          if(widget.locationList[index].isSelected==true)
                          {
                            if(widget.locationList[index]!=widget.locationList[checkCount])
                            {
                              widget.locationList[checkCount].isSelected != false;
                            }
                          }
                        }
                      });



                    },child:Container(
                      width:screenWidth/3,
                      height: 20,
                      decoration: BoxDecoration(border: Border.all(
                        color: Colors.black, // Set border color here
                        width: 1, // Set border width here
                      ),
                          color: Colours.swatch(widget.locationList[index].isSelected!?clrPurple:clrWhite),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(
                        widget.locationList[index].eventName.toString(),
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),),
                    )),
              ),
            ),

            Container(
              constraints: BoxConstraints(
                  minHeight: 0,
                  maxHeight: screenHeight *
                      0.2), // Adjust the maxHeight according to your layout
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFCEC0A1),
                  width: 2.0, // Set the border width
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButton<String>(

                onChanged: (newValue) {
setState(() {
  widget.sleepingHours = newValue!;
});


                },
                hint: const Text("How much sleep did you get the night before?"),
                items: widget.sleepingHoursList
                    .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                dropdownColor: Colors
                    .white, // Set the background color of the dropdown
                isDense: true, // Reduce height
                icon: Icon(Icons.arrow_drop_down,
                    color: Colors
                        .black), // Align the arrow to the right
                isExpanded:
                true, // Extend the button to the right
                underline: Container(),
              ),
            ),


      // Other widgets or content can go here
          ],
        ),
      ),
    );
  }

  Widget buildVirtueEntry2(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      {required String quadrantName,
        required String definition
      }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          Column(
            children: [
              Text(quadrantName), Text(definition)
            ],
          ),
            Divider(
              thickness: 0.5,
              color: Colours.swatch(clrHonesty),
              indent: 30,
              endIndent: 30,
            ),
            Container(
              child: Text(
                "Take a moment to write about what happened. What made it meaningful to you?",
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colours.swatch("#000000"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            textFieldNoteInput(context, widget.tfDescription, false),
            SizedBox(height: 8.0,),
            Container(
              child: Text(
                "What is the best piece of advice you could give someone about modeling this virtue throughout the day?",
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colours.swatch("#000000"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            textFieldNoteInput(context, widget.tfAdvice, false),
            SizedBox(height: 8.0),
            MaterialButton(
              onPressed: () {

              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFbab7d4), // Dark purple color
                    borderRadius:
                    BorderRadius.circular(5), // Adjusted border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 210,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Save Entry",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
  _selecteDate(BuildContext context,DateTime selectedDate, TextEditingController tfDate) async {




    final DateTime? picked = await  showDatePicker(

      confirmText: "Select",

      builder: (context, child) {
        return
          Theme(

              data: Theme.of(context).copyWith(

                colorScheme: ColorScheme.light(
                  primary: Colours.swatch(clrBlack), // header background color
                  onPrimary: Colours.swatch(clrWhite), // header text color
                  onSurface: Colours.swatch(clrBlack),
                  // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colours.swatch(clrBlack),

                    // button text color
                  ),
                ),
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width/1.1,
                    child: child,

                  ),
                ],
              ));


      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1985),
      lastDate: DateTime(DateTime.now().year+1),
      context: context,

    );
    print("Picked Date:$picked");
    if (picked != null && picked != selectedDate) {

      selectedDate = picked;
      setState(() {
        tfDate.text = DateFormat('dd-MMM-yyy').format(picked);
      });

      print("Picked Now:$picked");

    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colours.swatch(clrBlack), // header background color
              onPrimary: Colours.swatch(clrWhite), // header text color
              onSurface: Colours.swatch(clrBlack), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colours.swatch(clrBlack),

                // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != controller) {

      //widget._selectedTime = pickedTime;
      setState(() {
        controller.text= formatTime(pickedTime);
      });


    }
  }

}

Widget textFieldNoteInput(
    BuildContext context, TextEditingController controller, bool readOnly) {
  return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 120,
      child: TextFormField(
        cursorColor: Colors.black,
        cursorRadius: const Radius.circular(0),
        controller: controller,
        maxLines: 4,
        readOnly: readOnly,
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
            filled: true,
            fillColor: Colors.white),
      ));

}



