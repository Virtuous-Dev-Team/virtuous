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
    // addListToCalender(markers, context);
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colours.swatch(clrBackground),
          borderRadius: BorderRadius.circular(10)),
      child: CalendarCarousel<Event>(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.90,

        showOnlyCurrentMonthDate: true,
        weekendTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        weekDayBackgroundColor: Colours.white,
        // childAspectRatio: 1.5,

        //background: Colors.white,
        // markedDateCustomShapeBorder: CircleBorder(
        //   side: BorderSide(color: Colors.red), // Set border color to red
        // ),

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
        onDayPressed: (p0, p1) async {
          final userInfo = await ref.read(userInfoProviderr);
          String communityName = userInfo.currentCommunity;
          _selectSubjectDialog(context, p1, ref, communityName);
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

  Future<String?> _selectSubjectDialog(
      BuildContext context, List<Event> eventsList, ref, communityName) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Entries",
            textAlign: TextAlign.center,
            ),
          titleTextStyle: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colours.swatch(clrBlack),
          ),
          backgroundColor: Colours.swatch(clrBackground),
          shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10)),
          content: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.separated(
              itemCount: eventsList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                Event e = eventsList[index];
                return GestureDetector(
                    onTap: () async {
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
                                  color: communityName == "Legal"
                                      ? legalVirtueColors['${e.title}']
                                      : alAnVirtueColors['${e.title}'],
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
}

settingEntryProvider(ref, String? docId) async {
  final setEntryInfo = await ref.read(entryInfoProviderr);

  final entryInfo = await ref.read(usersRepositoryProvider).getEntry(docId);
  if (entryInfo['Success']) {
    setEntryInfo.updateEntry(entryInfo['response']);
    setEntryInfo.docIdFunc(docId);
  }
}
