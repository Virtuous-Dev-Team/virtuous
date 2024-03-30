// import 'dart:js';

import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import 'package:virtuetracker/api/users.dart';

import '../Models/LegalCalendarModel.dart';
import '../App_Configuration/apptheme.dart';

class CustomCalender {
  Widget customCalender(BuildContext context, List<LegalCalendarModel> markers,
      EventList<Event> _markedDateMap, ref) {
    print('calendar page $markers');
    addListToCalender(markers, context);
    List<MarkedDate> listy = [];
    listy.add(MarkedDate(color: Colors.black, date: DateTime.now()));
    return Container(
      decoration: BoxDecoration(
          color: Colours.swatch(clrBackground),
          borderRadius: BorderRadius.circular(10)),
      child: CalendarCarousel<Event>(
        height: MediaQuery.of(context).size.height * 0.50,
        showOnlyCurrentMonthDate: true,
        weekendTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        weekDayBackgroundColor: Colours.white,

        // childAspectRatio: 1.5,

        //background: Colors.white,
        // markedDateCustomShapeBorder: CircleBorder(
        //   side: BorderSide(color: Colors.red), // Set border color to red
        // ),

        // multipleMarkedDates: MultipleMarkedDates(markedDates: listy),
        isScrollable: true,
        leftButtonIcon: Icon(
          Icons.arrow_left_outlined,
          size: 30,
          color: Colors.black,
        ),
        rightButtonIcon: Icon(
          Icons.arrow_right_outlined,
          size: 30,
          color: Colors.black,
        ),

        weekFormat: false,

        todayButtonColor: Colours.transparent,
        todayTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        showHeaderButton: true,
        markedDatesMap: _markedDateMap,
        // markedDatesMap: CustomCalender._markedDateMap,
        // markedDateShowIcon: true,
        // markedDateIconMaxShown: 1,
        disableDayPressed: false,
        onDayPressed: (p0, p1) {
          print('day pressed $p1');
          _selectSubjectDialog(context, p1, ref);
        },

        weekdayTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        daysTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        headerTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        // markedDateMoreShowTotal:
        //     true, // null for not showing hidden events indicator
        // markedDateIconBuilder: (event) {
        //   return event.icon;
        // },
      ),
    );
  }

  static EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  addListToCalender(List<LegalCalendarModel> markers, context) {
    for (int i = 0; i < markers.length; i++) {
      if (markers[i].HonestyList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].HonestyList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].HonestyList![listLength],
            Event(
              date: markers[i].HonestyList![listLength],
              title: 'Honesty',
              // icon: _icon(markers[i].HonestyList![listLength].day.toString(),
              //     clrHonesty, clrBlack, context),
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrHonesty),
                ),
                width: 6,
                height: 6,
              ),

              // dot: Container(
              //   margin: EdgeInsets.symmetric(horizontal: 1.0),
              //   color: Colors.red,
              //   height: 5.0,
              //   width: 5.0,
              // ),
            ),
          );
        }
      }

      if (markers[i].CourageList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].CourageList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].CourageList![listLength],
            Event(
              date: markers[i].CourageList![listLength],
              title: 'Courage',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrCompassion),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].CourageList![listLength].day.toString(),
              //     clrCourage, clrBlack, context),
            ),
          );
        }
      }

      if (markers[i].CompassionList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].CompassionList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].CompassionList![listLength],
            Event(
              date: markers[i].CompassionList![listLength],
              title: 'Compassion',
              // icon: _icon(markers[i].CompassionList![listLength].day.toString(),
              //     clrCompassion, clrBlack, context),
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrCompassion),
                ),
                width: 6,
                height: 6,
              ),
            ),
          );
        }
      }

      if (markers[i].GenerosityList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].GenerosityList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].GenerosityList![listLength],
            Event(
              date: markers[i].GenerosityList![listLength],
              title: 'Generosity',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrGenerosity),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].GenerosityList![listLength].day.toString(),
              //     clrGenerosity, clrBlack, context),
            ),
          );
        }
      }
      if (markers[i].FidelityList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].FidelityList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].FidelityList![listLength],
            Event(
              date: markers[i].FidelityList![listLength],
              title: 'Fidelity',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrFidelity),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].FidelityList![listLength].day.toString(),
              //     clrFidelity, clrBlack, context),
            ),
          );
        }
      }
      if (markers[i].IntegrityList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].IntegrityList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].IntegrityList![listLength],
            Event(
              date: markers[i].IntegrityList![listLength],
              title: 'Integrity',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrIntegrity),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].IntegrityList![listLength].day.toString(),
              //     clrIntegrity, clrBlack, context),
            ),
          );
        }
      }
      if (markers[i].FairnessList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].FairnessList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].FairnessList![listLength],
            Event(
              date: markers[i].FairnessList![listLength],
              title: 'Fairness',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrFairness),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].FairnessList![listLength].day.toString(),
              //     clrFairness, clrBlack, context),
            ),
          );
        }
      }
      if (markers[i].SelfControlList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].SelfControlList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].SelfControlList![listLength],
            Event(
              date: markers[i].SelfControlList![listLength],
              title: 'Self-control',
              // icon: _icon(
              //     markers[i].SelfControlList![listLength].day.toString(),
              //     clrSelfControl,
              //     clrBlack,
              //     context),
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrSelfControl),
                ),
                width: 6,
                height: 6,
              ),
            ),
          );
        }
      }
      if (markers[i].PrudenceList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].PrudenceList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].PrudenceList![listLength],
            Event(
              date: markers[i].PrudenceList![listLength],
              title: 'Prudence',
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colours.swatch(clrPrudence),
                ),
                width: 6,
                height: 6,
              ),
              // icon: _icon(markers[i].PrudenceList![listLength].day.toString(),
              //     clrPrudence, clrBlack, context),
            ),
          );
        }
      }
    }
  }

  Widget _icon(String day, String color, String textColor, BuildContext context,
          ref) =>
      InkWell(
        onTap: () {
          print('calendar $day and $color');
          //here you have to pass the parameters which you need to send it from api according to the dates
          _selectSubjectDialog(context, [], ref);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colours.white,
          ),
          width: 20,
          height: 20,
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  color: Colours.swatch(textColor),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colours.swatch(color),
                  ),
                  width: 10,
                  height: 10,
                ),
              )
            ],
          ),
        ),
      );
  Future<String?> _selectSubjectDialog(
      BuildContext context, List<Event> eventsList, ref) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colours.swatch(clrWhite),
          // title: Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.cancel_outlined),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //     ),
          //   ],
          // ),
          content: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.separated(
              itemCount: eventsList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                Event e = eventsList[index];
                print('event: ${e.description}');
                return GestureDetector(
                    onTap: () async {
                      print(e.description);

                      await settingEntryProvider(ref, e.description);
                      Navigator.of(context).pop();
                      GoRouter.of(context).go('/analysis/editEntry');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: legalVirtueColors['${e.title}'],
                                  borderRadius: BorderRadius.circular(20)),
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 50,
                            ),
                            Text(
                              '${e.title}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "12:35 PM",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ));
              },
              separatorBuilder: (context, index) => Divider(
                endIndent: 0,
                indent: 0,
                height: MediaQuery.of(context).size.height / 30,
                color: Colours.swatch(clrText),
              ),
            ),
          ),
        );
      },
    );
  }

  // Future<Future<String?>> _selectSubjectDialog(
  //     BuildContext context, List<Event> eventsList) async {
  //   print(eventsList[1]);
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return AlertDialog(
  //             backgroundColor: Colours.swatch(clrWhite),

  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Icon(
  //                   Icons.cancel_outlined,
  //                   size: 25,
  //                   color: Colours.black,
  //                 )
  //               ],
  //             ),
  //             content: Container(
  //               height: MediaQuery.of(context).size.height / 3,
  //               child: SingleChildScrollView(
  //                 physics: AlwaysScrollableScrollPhysics(),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Expanded(
  //                         child: ListView.builder(
  //                             physics: AlwaysScrollableScrollPhysics(),
  //                             itemCount: eventsList.length,
  //                             shrinkWrap: true,
  //                             itemBuilder: (BuildContext context, index) {
  //                               print(eventsList[index]);
  //                               return Text("hello");
  //                               // Row(
  //                               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               //   children: [
  //                               //     Row(
  //                               //       mainAxisAlignment:
  //                               //           MainAxisAlignment.spaceBetween,
  //                               //       children: [
  //                               //         Container(
  //                               //           decoration: BoxDecoration(
  //                               //               color: Colours.swatch(clrHonesty),
  //                               //               borderRadius:
  //                               //                   BorderRadius.circular(20)),
  //                               //           width: 25,
  //                               //           height: 25,
  //                               //         ),
  //                               //         SizedBox(
  //                               //           width: MediaQuery.of(context).size.width /
  //                               //               50,
  //                               //         ),
  //                               //         Text(
  //                               //           "Honesty",
  //                               //           style: TextStyle(
  //                               //             fontSize: 13,
  //                               //             fontWeight: FontWeight.normal,
  //                               //             color: Colors.black,
  //                               //           ),
  //                               //         )
  //                               //       ],
  //                               //     ),
  //                               //     Text(
  //                               //       "12:35 PM",
  //                               //       style: TextStyle(
  //                               //         fontSize: 13,
  //                               //         fontWeight: FontWeight.normal,
  //                               //         color: Colors.black,
  //                               //       ),
  //                               //     ),
  //                               //   ],
  //                               // );
  //                             })),
  //                     // Row(
  //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //   children: [
  //                     //     Row(
  //                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //       children: [
  //                     //         Container(
  //                     //           decoration: BoxDecoration(
  //                     //               color: Colours.swatch(clrHonesty),
  //                     //               borderRadius: BorderRadius.circular(20)),
  //                     //           width: 25,
  //                     //           height: 25,
  //                     //         ),
  //                     //         SizedBox(
  //                     //           width: MediaQuery.of(context).size.width / 50,
  //                     //         ),
  //                     //         Text(
  //                     //           "Honesty",
  //                     //           style: TextStyle(
  //                     //             fontSize: 13,
  //                     //             fontWeight: FontWeight.normal,
  //                     //             color: Colors.black,
  //                     //           ),
  //                     //         )
  //                     //       ],
  //                     //     ),
  //                     //     Text(
  //                     //       "12:35 PM",
  //                     //       style: TextStyle(
  //                     //         fontSize: 13,
  //                     //         fontWeight: FontWeight.normal,
  //                     //         color: Colors.black,
  //                     //       ),
  //                     //     ),
  //                     //   ],
  //                     // ),
  //                     // Divider(
  //                     //   endIndent: 0,
  //                     //   indent: 0,
  //                     //   height: MediaQuery.of(context).size.height / 30,
  //                     //   color: Colours.swatch(clrText),
  //                     // ),
  //                     // Row(
  //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //   children: [
  //                     //     Row(
  //                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //       children: [
  //                     //         Container(
  //                     //           decoration: BoxDecoration(
  //                     //               color: Colours.swatch(clrFairness),
  //                     //               borderRadius: BorderRadius.circular(20)),
  //                     //           width: 25,
  //                     //           height: 25,
  //                     //         ),
  //                     //         SizedBox(
  //                     //           width: MediaQuery.of(context).size.width / 50,
  //                     //         ),
  //                     //         Text(
  //                     //           "Fairness",
  //                     //           style: TextStyle(
  //                     //             fontSize: 13,
  //                     //             fontWeight: FontWeight.normal,
  //                     //             color: Colors.black,
  //                     //           ),
  //                     //         )
  //                     //       ],
  //                     //     ),
  //                     //     Text(
  //                     //       "12:35 PM",
  //                     //       style: TextStyle(
  //                     //         fontSize: 13,
  //                     //         fontWeight: FontWeight.normal,
  //                     //         color: Colors.black,
  //                     //       ),
  //                     //     ),
  //                     //   ],
  //                     // ),
  //                     // Divider(
  //                     //   endIndent: 0,
  //                     //   indent: 0,
  //                     //   height: MediaQuery.of(context).size.height / 30,
  //                     //   color: Colours.swatch(clrText),
  //                     // ),
  //                     // Row(
  //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //   children: [
  //                     //     Row(
  //                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //       children: [
  //                     //         Container(
  //                     //           decoration: BoxDecoration(
  //                     //               color: Colours.swatch(clrSelfControl),
  //                     //               borderRadius: BorderRadius.circular(20)),
  //                     //           width: 25,
  //                     //           height: 25,
  //                     //         ),
  //                     //         SizedBox(
  //                     //           width: MediaQuery.of(context).size.width / 50,
  //                     //         ),
  //                     //         Text(
  //                     //           "Self-Control",
  //                     //           style: TextStyle(
  //                     //             fontSize: 13,
  //                     //             fontWeight: FontWeight.normal,
  //                     //             color: Colors.black,
  //                     //           ),
  //                     //         )
  //                     //       ],
  //                     //     ),
  //                     //     Text(
  //                     //       "12:35 PM",
  //                     //       style: TextStyle(
  //                     //         fontSize: 13,
  //                     //         fontWeight: FontWeight.normal,
  //                     //         color: Colors.black,
  //                     //       ),
  //                     //     ),
  //                     //   ],
  //                     // ),
  //                     // Divider(
  //                     //   endIndent: 0,
  //                     //   indent: 0,
  //                     //   height: MediaQuery.of(context).size.height / 30,
  //                     //   color: Colours.swatch(clrText),
  //                     // )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // you can use this for footer buttons if needed
  //             /* actions: <Widget>[
  //                   Divider(
  //                     height: MediaQuery
  //                         .of(context)
  //                         .size
  //                         .height / 40,
  //                     thickness: 1,
  //                     indent: 20,endIndent: 20,
  //                     color: Colours.swatch(clrText),

  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       TextButton(
  //                           onPressed: () {

  //                           },
  //                           child: Container(
  //                             height: 30, width: MediaQuery
  //                               .of(context)
  //                               .size
  //                               .width / 3.5,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 color: Colours.swatch(clrWhite)

  //                             )
  //                             ,
  //                             // color:Colours.swatch(Clr_Dialog_Btn_Ok),
  //                             child: Center(child: Text('Cancel', style: TextStyle(
  //                                 fontSize: 12,
  //                                 fontFamily: "Poppins",
  //                                 color: Colours.swatch(clrBlack))),
  //                             ),
  //                           )),
  //                       TextButton(
  //                           onPressed: ()
  //                           {
  //                           },
  //                           child: Container(
  //                             height: 30,
  //                             width: MediaQuery
  //                                 .of(context)
  //                                 .size
  //                                 .width / 3.5,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 color: Colours.swatch(clrBlack)

  //                             ),
  //                             // color:Colours.swatch(Clr_Dialog_Btn_Ok),
  //                             child: const Center(child: Text('Apply',
  //                                 style: TextStyle(fontSize: 12,
  //                                     fontFamily: "Poppins",
  //                                     color: Colours.white)),
  //                             ),
  //                           )),
  //                     ],
  //                   )

  //                 ],*/
  //           );
  //         });
  //       });
  // }
}

settingEntryProvider(ref, String? docId) async {
  final setEntryInfo = await ref.read(entryInfoProviderr);

  final entryInfo = await ref.read(usersRepositoryProvider).getEntry(docId);
  if (entryInfo['Success']) {
    setEntryInfo.updateEntry(entryInfo['response']);
    setEntryInfo.docIdFunc(docId);
    print('calendar page setting clicked entry ${setEntryInfo.quadrantUsed}');
  }
}
