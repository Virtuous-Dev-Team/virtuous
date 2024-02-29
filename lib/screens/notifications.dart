

import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../App_Configuration/apptheme.dart';
import '../App_Configuration/globalfunctions.dart';
import '../widgets/appBarWidget.dart';

class NotificationsPage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);
  bool cbenableNotifications=false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController tfNotifTime = TextEditingController();
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
{


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;


    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFDF9),
                    border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding:  EdgeInsets.only(top: screenHeight/50,bottom: screenHeight/50,
                    left: screenWidth/30,right: screenWidth/30,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              GoRouter.of(context).go('/SettingsPage/ChangePasswordPage');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Phone number",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.arrow_right,size: 25,)
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daily Reminders",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth/50,
                              ),
                              Checkbox(
                                visualDensity: VisualDensity.compact,


                                fillColor: MaterialStateProperty
                                    .resolveWith(getColor),
                                side: BorderSide(
                                  color: Colours.swatch(clrWhite),),
                                checkColor: Colors.white,
                                value: widget.cbenableNotifications,
                                onChanged: (bool? value) {
                                  print(value);

                                  setState(() {

                                    widget.cbenableNotifications=value!;
                                  });




                                },),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              _selectTime(context,widget.tfNotifTime);
                            },
                            child: Container(

                              decoration: BoxDecoration(
                                color: Colours.swatch(clrBackground), // Dark purple color

                              ),
                              width: screenWidth/1.1,
                              height: 40,
                              child: Center(
                                child: Text(
                                  "Select a time to receive notifications",
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
                          SizedBox(
                            height: screenHeight/50,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notifications Time",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth/50,
                              ),
                              Container(
                                width: screenWidth/4,
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFCEC0A1),
                                    width: 2.0, // Set the border width
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child:
                                //textFieldTimeInput(context,tfNotifTime,"Start Time"),
                                TextField(
                                  enabled: false,
                                  controller: widget.tfNotifTime,
                                  onChanged: (newValue) {
                                    setState(() {

                                    });
                                  },

                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: '',
                                    hintStyle: GoogleFonts.tinos(
                                        textStyle: TextStyle(color: Colors.black)),
                                    border: InputBorder.none, // Hide the default border
                                  ),
                                ),
                              ),
                            ],
                          ),


                        ],),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.swatch(clrBackground), // Dark purple color
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
                              "Submit",
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
                    ],
                  ),

                ),
              ),
            )));
  }


  Widget textFieldTimeInput(BuildContext context,TextEditingController controller,String hintText,[String? clrBasic,String? clrIcon,String? clrDivider]){
    return InkWell(
      onTap: (){
        _selectTime(context,controller);
      },
      child: SizedBox(width: MediaQuery.of(context).size.width/5,
          height: 40,
          child:
          TextFormField(

            enabled: false,
            cursorColor: Colours.swatch(clrBlack),
            cursorRadius: const Radius.circular(0),
            controller: controller,
            /*   validator: (value){
              if (value!.isEmpty
              ){
                return "enter $hintText";
              }
              else {
                return null;
              }
            },*/

            style: TextStyle(color:clrBasic==null?Colours.swatch(clrWhite):Colours.swatch(clrBasic) ,fontFamily: "Poppins",fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: '',
              hintStyle: GoogleFonts.tinos(
                  textStyle: TextStyle(color: Colors.black)),
              border: InputBorder.none, // Hide the default border
            ),

          )),
    );
  }


  Future<void> _selectTime(BuildContext context,TextEditingController controller) async {
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
      context: context, initialTime: TimeOfDay.now(),

    );

    if (pickedTime != null && pickedTime != widget._selectedTime) {
      setState(() {
        //widget._selectedTime = pickedTime;

        widget.tfNotifTime.text=formatTime(pickedTime);
      });
    }
  }

  String formatTime(TimeOfDay timeOfDay) {
    // Use the format method of TimeOfDay to get a formatted string
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat('h:mm a');
    return format.format(dateTime);
  }
}
