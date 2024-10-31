import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/Models/ChartDataModel.dart';

class Stats {
  final userCollectionRef = FirebaseFirestore.instance.collection("Users");

  // Map for getting colors from community name.
  // Maybe move to config in the future
  Map<String, Map<String, Color>> communityColorLists = {
    'Legal': legalVirtueColors,
    'Alcoholics Anonymous': alAnVirtueColors
    // Future communities here
  };

  // Get stats for Calendar and piechart/top_bottom virtues
  Future<dynamic> getAllStats(String communityName) async {
    try {
      // Make the pie chart and get the top and bottom 3 virtues
      final quadrantLists = await getQuadrantsUsedList(communityName);
      print(quadrantLists);
      // Get the calendar information
      final calendar = await buildCalendar(communityName);
      // Logic for requests
      // TODO: is there a better/cleaner way to do this?
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

  // Build the pie chart and get the top and bottom 3 virtues
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

        // Grab the existing information about how often a user has used each virtue
        Map<String, int> quadrantsUsedList =
            Map<String, int>.from(quadrantsUsedData[communityName]);

        // Add each to a pie chart
        // TODO: make the color usage more easily reused
        List<ChartData> charty = [];
        quadrantsUsedList.forEach((key, value) {
          double num = value.floorToDouble();
          charty.add(ChartData(
              key,
              num,
              communityName == "Legal"
                  ? legalVirtueColors[key]
                  : alAnVirtueColors[key]));
        });
        // Sort the results to find and return the top and bottom virtues
        List<MapEntry<String, int>> sortedList =
            quadrantsUsedList.entries.toList();
        sortedList.sort((a, b) => b.value.compareTo(a.value));
        // print('sorted list: $sortedList');

        //Get the top 3 entries
        Map<String, int> top3Map = Map.fromEntries(sortedList.take(3));
        // Get the bottom 3 entries
        Map<String, int> bottom3Map =
            Map.fromEntries(sortedList.skip(sortedList.length - 3));

        // Build the final object to respond with
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

  // Parsing time stamp function
  DateTime parseTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  // Queries for virtue information, then uses buildCalendarList to create calendar
  Future<dynamic> buildCalendar(String communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      EventList<Event> _markedDateMap = EventList<Event>(
        events: {},
      );
      // Query for all virtues matching the community
      QuerySnapshot querySnapshot = await userCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .where('communityName', isEqualTo: communityName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Build calendar from results
        _markedDateMap = buildCalendarList(querySnapshot, communityName);

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

  // Builds the calendar using the information from the query
  EventList<Event> buildCalendarList(QuerySnapshot querySnapshot, String communityName) {

    EventList<Event> _markedDateMap = EventList<Event>(
      events: {},
    );

    // Creates calendar from queried totalData subcollection
    querySnapshot.docs.forEach((element) {
      dynamic val = element.data();
      Timestamp dateEntered = val['dateEntried'];
      String virtueUsed = val["quadrantUsed"];
      // Get matching communityColors for current community
      Map<String, Color> communityColors = communityColorLists[communityName] ?? {};
      DateTime d = parseTimestamp(dateEntered);

      // Combine each entry into a list of events
      _markedDateMap.add(
        d,
        Event(
          date: d,
          title: virtueUsed,
          description: element.id,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: communityColors[virtueUsed],
            ),
            width: 6,
            height: 6,
          ),
        ),
      );
    });

    return _markedDateMap;
  }




}


// Provider to use Stats class in other files
final statsRepositoryProvider = Provider<Stats>((ref) {
  return Stats();
});
