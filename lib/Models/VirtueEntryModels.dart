// class Events {
//   Events(this.eventName, this.isSelected);
//   final String? eventName;
//   bool? isSelected;
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';

class EntryProvider extends ChangeNotifier {
  // Fields to store entry data
  late String communityName;
  late String quadrantUsed;
  late String quadrantColor;
  // late bool shareLocation;
  // late bool shareEntry;
  late String sleepHours;
  late String adviceAnswer;
  late String whatHappenedAnswer;
  late List<Events> eventList;
  late List<Events> whoWereWithYouList;
  late List<Events> whereWereYouList;
  late String dateAndTimeOfOccurence;
  late String docId;
  // EntryProvider({
  //   required this.communityName,
  //   required this.quadrantUsed,
  //   required this.quadrantColor,
  //   required this.shareLocation,
  //   required this.shareEntry,
  //   required this.sleepHours,
  //   required this.adviceAnswer,
  //   required this.whatHappenedAnswer,
  //   required this.eventList,
  //   required this.whoWereWithYouList,
  //   required this.whereWereYouList,
  //   required this.dateAndTimeOfOccurence,
  // });
  void docIdFunc(String value) {
    docId = value;
  }

  // Function to update entry data...
  void updateEntry(Map<String, dynamic> data) {
    // Update each field with the corresponding value from the map
    communityName = data['communityName'];
    quadrantUsed = data['quadrantUsed'];
    quadrantColor = data['quadrantColor'];
    // shareLocation = data['shareLocation'];
    // shareEntry = data['shareEntry'];
    sleepHours = data['sleepHours'];
    adviceAnswer = data['adviceAnswer'];
    whatHappenedAnswer = data['whatHappenedAnswer'];
    eventList = mapToListOfEvents(data['eventList']);
    whoWereWithYouList = mapToListOfEvents(data['whoWereWithYouList']);
    whereWereYouList = mapToListOfEvents(data['whereWereYouList']);
    dateAndTimeOfOccurence = data['dateAndTimeOfOccurence'];

    // Notify listeners that the data has changed
    notifyListeners();
  }

  // Function to convert maps to lists of Events
  List<Events> mapToListOfEvents(Map<String, dynamic> map) {
    return map.entries.map((entry) => Events(entry.key, entry.value)).toList();
  }
}

// Events class definition
class Events {
  final String eventName;
  bool isSelected;

  Events(this.eventName, this.isSelected);
}

final entryInfoProviderr = ChangeNotifierProvider((ref) => EntryProvider());
