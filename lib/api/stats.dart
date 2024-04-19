import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/Models/LegalCalendarModel.dart';
import 'package:virtuetracker/Models/ChartDataModel.dart';

class Stats {
  final userCollectionRef = FirebaseFirestore.instance.collection("Users");

  Future<dynamic> getAllStats(String communityName) async {
    try {
      final quadrantLists = await getQuadrantsUsedList(communityName);
      print(quadrantLists);
      final calendar = await buildCalendar(communityName);
      if (quadrantLists['Success'] && calendar['Success']) {
        return {
          'Success': [true, true],
          "quadrantLists": quadrantLists["response"],
          "calendar": calendar['response']
        };
      } else if (quadrantLists['Success'] && calendar['Success'] == false) {
        return {
          'Success': [true, false],
          "quadrantLists": quadrantLists["response"],
          "calendar": calendar['Error']
        };
      } else if (quadrantLists['Success'] == false && calendar['Success']) {
        return {
          'Success': [false, true],
          "quadrantLists": quadrantLists["Error"],
          "calendar": calendar['response']
        };
      } else {
        return {
          'Success': [false, false],
          "quadrantLists": quadrantLists["Error"],
          "calendar": calendar['Error']
        };
      }
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> getQuadrantsUsedList(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      DocumentSnapshot documentSnapshot =
          await userCollectionRef.doc(user.uid).get();

      if (documentSnapshot.exists) {
        dynamic quadrantsUsedData = documentSnapshot["quadrantUsedData"];

        Map<String, int> quadrantsUsedList =
            Map<String, int>.from(quadrantsUsedData[communityName]);

        List<ChartData> charty = [];
        quadrantsUsedList.forEach((key, value) {
          double num = value.floorToDouble();
          charty.add(ChartData(
              key,
              num,
              communityName == "Legal"
                  ? legalVirtueColors['$key']
                  : alAnVirtueColors['$key']));
        });
        List<MapEntry<String, int>> sortedList =
            quadrantsUsedList.entries.toList();
        sortedList.sort((a, b) => b.value.compareTo(a.value));
        // print('sorted list: $sortedList');
        Map<String, int> top3Map = Map.fromEntries(sortedList.take(3));

        // Get the bottom 3 entries
        Map<String, int> bottom3Map =
            Map.fromEntries(sortedList.skip(sortedList.length - 3));

        // Make an object for top 3 and bottom 3 and write method to sort them

        final response = {};
        response["pieChart"] = charty;
        response["topThreeVirtues"] = top3Map;
        response["bottomThreeVirtues"] = bottom3Map;
        // print(response);

        return {"Success": true, "response": response};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print('error in stats.dart $error');
      return {'Success': false, 'Error': error};
    }
  }

  DateTime parseTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<dynamic> buildCalendar(String communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      EventList<Event> _markedDateMap = new EventList<Event>(
        events: {},
      );
      QuerySnapshot querySnapshot = await userCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .where('communityName', isEqualTo: communityName)
          .get();
      // print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        //
        switch (communityName) {
          case 'Legal':
            {
              _markedDateMap = buildLegalCalendarList(querySnapshot);
            }
          case 'Alcoholics Anonymous':
            {
              _markedDateMap = buildAACalendarList(querySnapshot);
            }
        }
        print('stats dart $_markedDateMap');
        return {'Success': true, 'response': _markedDateMap};
        // dynamic totalData = querySnapshot['totalData'];
        // print(totalData);
      } else {
        return {'Success': false, 'Error': 'No entries in your account'};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  EventList<Event> buildLegalCalendarList(QuerySnapshot querySnapshot) {
    List<DateTime> HonestyDates = [];
    List<DateTime> CourageDates = [];
    List<DateTime> CompassionDates = [];
    List<DateTime> GenerosityDates = [];
    List<DateTime> FidelityDates = [];
    List<DateTime> IntegrityDates = [];
    List<DateTime> FairnessDates = [];
    List<DateTime> SelfControlDates = [];
    List<DateTime> PrudenceDates = [];
    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {},
    );
    querySnapshot.docs.forEach((element) {
      // DocumentSnapshot documentSnapshot = element["dateEntried"];

      dynamic val = element.data();
      Timestamp dateEntried = val['dateEntried'];
      String virtueUsed = val["quadrantUsed"];
      // Timestamp timestamp =
      //     Timestamp.fromMillisecondsSinceEpoch(val['dateEntried']);

      // Convert the Timestamp to a DateTime object
      // DateTime dateTime = timestamp.toDate();
      DateTime d = parseTimestamp(dateEntried);
      switch (virtueUsed) {
        case "Honesty":
          {
            HonestyDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Courage":
          {
            CourageDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Compassion":
          {
            CompassionDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Generosity":
          {
            GenerosityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Fidelity":
          {
            FidelityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Integrity":
          {
            IntegrityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Fairness":
          {
            FairnessDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Self-control":
          {
            SelfControlDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Prudence":
          {
            PrudenceDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: legalVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
      }
    });
    LegalCalendarModel model = LegalCalendarModel(
        CompassionList: CompassionDates,
        CourageList: CourageDates,
        FairnessList: FairnessDates,
        FidelityList: FidelityDates,
        GenerosityList: GenerosityDates,
        HonestyList: HonestyDates,
        IntegrityList: IntegrityDates,
        PrudenceList: PrudenceDates,
        SelfControlList: SelfControlDates);
    List<LegalCalendarModel> calendarData = [];
    calendarData.add(model);

    return _markedDateMap;
  }

  EventList<Event> buildAACalendarList(QuerySnapshot querySnapshot) {
    List<DateTime> HonestyDates = [];
    List<DateTime> HopeDates = [];
    List<DateTime> SurrenderDates = [];

    List<DateTime> CourageDates = [];
    List<DateTime> IntegrityDates = [];
    List<DateTime> WillingnessDates = [];
    List<DateTime> HumilityDates = [];
    List<DateTime> LoveDates = [];
    List<DateTime> ResponsibilityDates = [];
    List<DateTime> DisciplineDates = [];
    List<DateTime> AwarenessDates = [];
    List<DateTime> ServiceDates = [];

    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {},
    );
    querySnapshot.docs.forEach((element) {
      // DocumentSnapshot documentSnapshot = element["dateEntried"];

      dynamic val = element.data();
      Timestamp dateEntried = val['dateEntried'];
      String virtueUsed = val["quadrantUsed"];
      // Timestamp timestamp =
      //     Timestamp.fromMillisecondsSinceEpoch(val['dateEntried']);

      // Convert the Timestamp to a DateTime object
      // DateTime dateTime = timestamp.toDate();
      DateTime d = parseTimestamp(dateEntried);
      switch (virtueUsed) {
        case "Honesty":
          {
            HonestyDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Courage":
          {
            CourageDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Hope":
          {
            HopeDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Surrender":
          {
            SurrenderDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Integrity":
          {
            IntegrityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Willingness":
          {
            WillingnessDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Humility":
          {
            HumilityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Love":
          {
            LoveDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Responsibility":
          {
            ResponsibilityDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Discipline":
          {
            DisciplineDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Awareness":
          {
            AwarenessDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
        case "Service":
          {
            ServiceDates.add(d);
            _markedDateMap.add(
              d,
              Event(
                date: d,
                title: virtueUsed,
                description: element.id,
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: alAnVirtueColors['$virtueUsed'],
                  ),
                  width: 6,
                  height: 6,
                ),
              ),
            );
          }
      }
    });
    // LegalCalendarModel model = LegalCalendarModel(
    //     CompassionList: CompassionDates,
    //     CourageList: CourageDates,
    //     FairnessList: FairnessDates,
    //     FidelityList: FidelityDates,
    //     GenerosityList: GenerosityDates,
    //     HonestyList: HonestyDates,
    //     IntegrityList: IntegrityDates,
    //     PrudenceList: PrudenceDates,
    //     SelfControlList: SelfControlDates);
    // List<LegalCalendarModel> calendarData = [];
    // calendarData.add(model);

    return _markedDateMap;
  }
}

final statsRepositoryProvider = Provider<Stats>((ref) {
  return Stats();
});



// List<DateTime> SelfControlDates = [
//       DateTime(2024, 02, 22),
//       DateTime(2024, 02, 24),
//       DateTime(2024, 02, 26),
//     ];
//     calendarData.add(CalendarModel(
        // CompassionList: CompassionDates,
        // CourageList: CourageDates,
        // FairnessList: FairnessDates,
        // FidelityList: FidelityDates,
        // GenerosityList: GenerosityDates,
        // HonestyList: HonestyDates,
        // IntegrityList: IntegrityDates,
        // PrudenceList: PrudenceDates,
        // SelfControlList: SelfControlDates));
