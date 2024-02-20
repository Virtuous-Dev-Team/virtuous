import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../Models/CalendarModel.dart';
import '../App_Configuration/apptheme.dart';

class CustomCalender {
  Widget customCalender(BuildContext context, List<CalendarModel> markers) {
    addListToCalender(markers);
    return Container(
      decoration: BoxDecoration(
          color: Colours.swatch(clrBackground),
          borderRadius: BorderRadius.circular(10)),
      child: CalendarCarousel<Event>(
        height: MediaQuery.of(context).size.height * 0.54,
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
        markedDatesMap: CustomCalender._markedDateMap,

        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,

        disableDayPressed: false,

        weekdayTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        daysTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        headerTextStyle: TextStyle(color: Colours.swatch(clrBlack)),
        markedDateMoreShowTotal:
            null, // null for not showing hidden events indicator
        markedDateIconBuilder: (event) {
          return event.icon;
        },
      ),
    );
  }

  static EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  addListToCalender(List<CalendarModel> markers) {
    for (int i = 0; i < markers.length; i++) {
      if (markers[i].HonestyList!.isNotEmpty) {
        for (int listLength = 0;
            listLength < markers[i].HonestyList!.length;
            listLength++) {
          _markedDateMap.add(
            markers[i].HonestyList![listLength],
            Event(
              date: markers[i].HonestyList![listLength],
              title: 'Event Honesty',
              icon: _icon(markers[i].HonestyList![listLength].day.toString(),
                  clrHonesty, clrBlack),
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
              title: 'Event Courage',
              icon: _icon(markers[i].CourageList![listLength].day.toString(),
                  clrCourage, clrBlack),
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
              title: 'Event Compassion',
              icon: _icon(markers[i].CompassionList![listLength].day.toString(),
                  clrCompassion, clrBlack),
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
              title: 'Event Generosity',
              icon: _icon(markers[i].GenerosityList![listLength].day.toString(),
                  clrGenerosity, clrBlack),
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
              title: 'Event Fidelity',
              icon: _icon(markers[i].FidelityList![listLength].day.toString(),
                  clrFidelity, clrBlack),
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
              title: 'Event Integrity',
              icon: _icon(markers[i].IntegrityList![listLength].day.toString(),
                  clrIntegrity, clrBlack),
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
              title: 'Event Fairness',
              icon: _icon(markers[i].FairnessList![listLength].day.toString(),
                  clrFairness, clrBlack),
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
              title: 'Event SelfControl',
              icon: _icon(
                  markers[i].SelfControlList![listLength].day.toString(),
                  clrSelfControl,
                  clrBlack),
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
              title: 'Event Prudence',
              icon: _icon(markers[i].PrudenceList![listLength].day.toString(),
                  clrPrudence, clrBlack),
            ),
          );
        }
      }
    }
  }

  static Widget _icon(String day, String color, String textColor) => Container(
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
      );
}
