import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class Users {
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";
  final geo = GeoFlutterFire();
  List<DocumentSnapshot> parsedEntryList = [];
  Map<String, int?> chartData = {
    "Honesty": 0,
    "Courage": 0,
    "Compassion": 0,
    "Generosity": 0,
    "Fidelity": 0,
    "Integrity": 0,
    "Fairness": 0,
    "Self-control": 0,
    "Prudence": 0
  };

  // Add different communitiesst, and write getter function per commmunity.

  final Map<String, Map<String, Map<String, dynamic>>> quadrantLists = {
    "Legal": {
      "Legal": {
        "Honesty": 0,
        "Courage": 0,
        "Compassion": 0,
        "Generosity": 0,
        "Fidelity": 0,
        "Integrity": 0,
        "Fairness": 0,
        "Self-control": 0,
        "Prudence": 0
      }
    },
    "Alcoholics Anonymous": {
      "Alcoholics Anonymous": {
        "Honesty": 0,
        "Hope": 0,
        "Surrender": 0,
        "Courage": 0,
        "Integrity": 0,
        "Willingness": 0,
        "Humility": 0,
        "Love": 0,
        "Responsibility": 0,
        "Discipline": 0,
        "Awareness": 0,
        "Service": 0,
      }
    }
  };

  // Done,
  // Future<dynamic> addVirtueEntry(currentCommunity, quadrantUsed, quadrantColor,
  //     quadrantAnswers, shareLocation, shareEntries) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       return {'Success': false, 'Error': 'User not found'};
  //     }
  //     final totalDataObject = {
  //       "communityName": currentCommunity,
  //       "quadrantUsed": quadrantUsed,
  //       "quadrantColor": quadrantColor,
  //       "dateEntried": FieldValue.serverTimestamp(),
  //       "quadrantAnswers": quadrantAnswers
  //     };
  //     // Add virtue entry to totalData subcollection
  //     await usersCollectionRef
  //         .doc(user.uid)
  //         .collection("totalData")
  //         .add(totalDataObject);

  //     // Maybe add a check to see if it completed
  //     await updateQuadrantsUsed(currentCommunity, quadrantUsed);
  //     if (shareLocation && shareEntries) {
  //       final CommunityShared communitySharedApi = CommunityShared();
  //       await communitySharedApi
  //           .addSharedVirtueEntry(
  //               quadrantUsed, quadrantColor, shareLocation, currentCommunity)
  //           .catchError((e) => print(e));
  //     }
  //     return {'Success': true, "response": "Entry added"};
  //   } on FirebaseException catch (error) {
  //     print('Error ${error.message}');
  //     return {'Success': false, 'Error': error.message};
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<dynamic> editEntry(
      String communityName,
      String quadrantUsed,
      String quadrantColor,
      bool shareLocation,
      bool shareEntry,
      String sleepHours,
      String adviceAnswer,
      String whatHappenedAnswer,
      List<Events> eventList,
      List<Events> whoWereWithYouList,
      List<Events> whereWereYouList,
      String dateAndTimeOfOccurence,
      String docId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': 'User not found'};
      }
      Map<String, bool> eventsMap = {};
      eventList.forEach((event) {
        eventsMap[event.eventName!] = event.isSelected!;
      });
      Map<String, bool> whoWereWithYouMap = {};
      whoWereWithYouList.forEach((event) {
        whoWereWithYouMap[event.eventName!] = event.isSelected!;
      });
      Map<String, bool> whereWereYouMap = {};
      whereWereYouList.forEach((event) {
        whereWereYouMap[event.eventName!] = event.isSelected!;
      });
      final totalDataObject = {
        "communityName": communityName,
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "dateEntried": FieldValue.serverTimestamp(),
        "sleepHours": sleepHours,
        "eventList": eventsMap,
        "whatHappenedAnswer": whatHappenedAnswer,
        "adviceAnswer": adviceAnswer,
        "whoWereWithYouList": whoWereWithYouMap,
        "whereWereYouList": whereWereYouMap,
        "dateAndTimeOfOccurence": dateAndTimeOfOccurence
      };
      await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .doc(docId)
          .update(totalDataObject);

      return {'Success': true, 'msg': 'Successfully edited entry'};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> getEntry(String docId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': 'User not found'};
      }
      DocumentSnapshot<Map<String, dynamic>> res = await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .doc(docId)
          .get();
      if (res.exists) {
        return {'Success': true, 'response': res.data()};
      }
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> addEntry(
      String communityName,
      String quadrantUsed,
      String quadrantColor,
      bool shareLocation,
      bool shareEntry,
      String sleepHours,
      String adviceAnswer,
      String whatHappenedAnswer,
      List<Events> eventList,
      List<Events> whoWereWithYouList,
      List<Events> whereWereYouList,
      String dateAndTimeOfOccurence) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': 'User not found'};
      }

      Map<String, bool> eventsMap = {};
      eventList.forEach((event) {
        eventsMap[event.eventName!] = event.isSelected!;
      });
      Map<String, bool> whoWereWithYouMap = {};
      whoWereWithYouList.forEach((event) {
        whoWereWithYouMap[event.eventName!] = event.isSelected!;
      });
      Map<String, bool> whereWereYouMap = {};
      whereWereYouList.forEach((event) {
        whereWereYouMap[event.eventName!] = event.isSelected!;
      });

      final totalDataObject = {
        "communityName": communityName,
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "dateEntried": FieldValue.serverTimestamp(),
        "sleepHours": sleepHours,
        "eventList": eventsMap,
        "whatHappenedAnswer": whatHappenedAnswer,
        "adviceAnswer": adviceAnswer,
        "whoWereWithYouList": whoWereWithYouMap,
        "whereWereYouList": whereWereYouMap,
        "dateAndTimeOfOccurence": dateAndTimeOfOccurence
      };
      // Add virtue entry to totalData subcollection
      await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .add(totalDataObject);

      // Maybe add a check to see if it completed
      final updateQuadrant =
          await updateQuadrantsUsed(communityName, quadrantUsed);
      if (updateQuadrant["Success"] == false) {
        print('Error updating quadrant used: ${updateQuadrant['Error']}');
      }
      if (shareLocation && shareEntry) {
        final CommunityShared communitySharedApi = CommunityShared();
        final addToShared = await communitySharedApi.addSharedVirtueEntry(
            quadrantUsed, quadrantColor, shareLocation, communityName);
        if (addToShared["Success"] == false) {
          print(
              'Error adding quadrant to shared collection: ${addToShared['Error']}');
        }
      }
      return {'Success': true, "response": "Entry added"};
    } on FirebaseException catch (error) {
      print('Error ${error.message}');
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print('Error ${error}');
      return {'Success': false, 'Error': error};
    }
  }

  // Tested and is working as intended
  Future<dynamic> updateQuadrantsUsed(communityName, quadrantUsed) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }

      // Increment whichever quadrant was used
      await usersCollectionRef.doc(user.uid).update({
        'quadrantUsedData.${communityName}.${quadrantUsed}':
            FieldValue.increment(1),
      });
      return {'Success': true, "response": "Entry added"};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print('Error ${error}');
      return {'Success': false, 'Error': error};
    }
  }

  // Done
  Future getMostRecentEntries(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }
      QuerySnapshot querySnapshot = await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .where("communityName", isEqualTo: communityName)
          .orderBy('dateEntried', descending: true)
          .limit(12)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate over the documents
        dynamic recentEntriesList = querySnapshot.docs.map((document) {
          Timestamp? timestamp = document['dateEntried'] as Timestamp?;
          String dateEntered =
              timestamp != null ? timestamp.toDate().toString() : "Unknown";
          return {
            "docId": document.id,
            "communityName": document["communityName"],
            "quadrantUsed": document["quadrantUsed"] ?? "Error",
            "quadrantColor": document["quadrantColor"],
            "dateEntried": dateEntered,
            // add other stuff
          };
        }).toList();

        // print(recentEntriesList);
        return {'Success': true, "response": recentEntriesList};
      } else {
        return {'Success': false, 'Error': "Query is empty"};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'error': error.message};
    } catch (error) {
      print('Error getting recent entries in users.dart $error');
      return {'Success': false, 'error': error};
    }
  }

  // Working, need to add phone number verification
  Future<dynamic> surveyInfo(
      String currentPosition,
      String careerLength,
      String currentCommunity,
      String reason,
      bool shareEntries,
      bool shareLocation,
      bool allowNotifications,
      String phoneNumber,
      String notificationTime,
      bool phoneVerified,
      dynamic userLocation) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': 'User not found'};
      }
      final careerInfo = {
        "currentPosition": currentPosition,
        "careerLength": careerLength
      };

      final userObject = {
        "currentCommunity": currentCommunity,
        "userLocation": userLocation,
        "reasons": reason,
        "shareEntries": shareEntries,
        "shareLocation": shareLocation
      };
      final notificationPreferences = {
        "allowNotifications": allowNotifications,
        "notificationTime": notificationTime,
        "fcmToken": null,
        "phoneVerified": phoneVerified
      };

      userObject["careerInfo"] = careerInfo;
      userObject["notificationPreferences"] = notificationPreferences;

      userObject["quadrantUsedData"] =
          quadrantLists[currentCommunity] ?? 'Error';
      print('$userObject');
      await usersCollectionRef
          .doc(user.uid)
          .set(userObject, SetOptions(merge: true));
      return {'Success': true, 'response': "Added profile info"};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (e) {
      print('Error in survey api $e');
    }
  }

  // phone number verification
  Future<dynamic> sendOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await _firebaseAuth
          .verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: "+1$phone",
        verificationCompleted: (phoneAuthCredential) async {
          return;
        },
        verificationFailed: (error) async {
          return;
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          return;
        },
      )
          .onError((error, stackTrace) {
        errorStep();
      });
    } on FirebaseAuthException catch (e) {
      print('firebase auth exception $e');
    } catch (error) {
      errorStep();
    }
  }

  // verify otp code
  Future<dynamic> confirmOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);
    User? currentUser = await _firebaseAuth.currentUser!;

    // instead of signing in with credential, link credential to signed in user account
    try {
      currentUser.linkWithCredential(cred).then((value) {
        // Verfied now perform something or exit.
        return {"Success": true, "response": "User phone number verified"};
      }).catchError((e) {
        // An error occured while linking
        return {"Success": false, "Error": "error linking credential"};
      });
    } catch (e) {
      // General error
      return {"Success": false, "Error": e};
    }

    // try {
    //   final user = await _firebaseAuth.signInWithCredential(cred);
    //   if(user.user != null) {
    //     return "Success";
    //   } else {
    //     return "error in OTP verification";
    //   }
    // }
    // on FirebaseAuthException catch(e) {
    //   return e.message.toString();
    // }
    // catch(e) {
    //   return e.toString();
    // }
  }

  // Used whenever we need to to ask for user permissions for location
  // Done and tested
  // updated to geoflutterfire
  Future<dynamic> addUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // await Geolocator.openAppSettings();
        // bool opened = await Geolocator.openLocationSettings();
        // if (opened) {
        //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
        //   print('here after $serviceEnabled');
        //   if (serviceEnabled) {
        //     return await addUserLocation();
        //   }
        // }

        return {'Success': false, 'Error': 'Location services are disabled'};
      }
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      print('Location services are enabled');

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {'Success': false, 'Error': 'Location permissions are denied'};
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission are denied until User changes it in settings, we can't request permission.
        return {
          'Success': false,
          'Error': 'Location permissions are denied permanently'
        };
      }

      print('Location services are allowed to check location');

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      GeoFirePoint geoFireLocation =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      return {"Success": true, "response": geoFireLocation};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Done and tested
  // updated to geoflutterfire
  Future<dynamic> getUpdatedLocation(shareLocation) async {
    try {
      if (shareLocation) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        GeoFirePoint geoFireLocation = geo.point(
            latitude: position.latitude, longitude: position.longitude);
        return geoFireLocation;
      } else {
        return Future.error({
          'Success': false,
          'Error':
              'User location sharing is off, return to app settings to turn them on'
        });
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Done
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': 'No user found'};
      }
      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc(user.uid).get();
      if (documentSnapshot.exists) {
        final userInfo = documentSnapshot.data() as Map<String, dynamic>;

        return {'Success': true, "response": userInfo};
      }
      return {'Success': false, "Error": 'User not found in Users collection'};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Stream<List<DocumentSnapshot<Object?>>> getThoseEntries(
      bool shareLocation, double radius) async* {
    final sharedCollectionRef =
        FirebaseFirestore.instance.collection('CommunitySharedData');
    final geoRef = geo.collection(collectionRef: sharedCollectionRef);
    if (shareLocation) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      GeoFirePoint geoFireLocation =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      print('radius $radius');
      var eventsStream = geoRef.within(
          center: geoFireLocation,
          radius: radius,
          field: 'userLocation',
          strictMode: true);
      await for (var event in eventsStream) {
        yield event; // Yield the list of document snapshots
      }
    }
  }

  // Future<dynamic> parseNearbyEntries(
  //     List<DocumentSnapshot> nearbyEntryList, String timeFrame) async {
  //   DateTime startDate;
  //   DateTime today = DateTime.now();

  //   // get start date for qualified entries
  //   if (timeFrame == 'Last week') {
  //     startDate = today.subtract(const Duration(days: 7));
  //   } else if (timeFrame == 'Last 3 months') {
  //     startDate = today.subtract(const Duration(days: 90));
  //   } else if (timeFrame == 'Last 6 months') {
  //     startDate = today.subtract(const Duration(days: 180));
  //   } else if (timeFrame == 'Last year') {
  //     startDate = today.subtract(const Duration(days: 365));
  //   } else {
  //     print('invalid time frame');
  //     startDate = today.subtract(const Duration(days: 0));
  //   }

  //   //get entries within selected time frame
  //   for (var i = 0; i < nearbyEntryList.length; i++) {
  //     final entry = nearbyEntryList[0].data() as Map;
  //     Timestamp? entryTime = entry['dateEntried'] as Timestamp?;
  //     DateTime? dateEntered = entryTime != null ? entryTime.toDate() : today;

  //     // if date of entry is within time frame, add to parsed list
  //     if (dateEntered.isAfter(startDate)) {
  //       parsedEntryList.add(nearbyEntryList[i]);
  //     }
  //   }

  //   // collect frequency of each virtue
  //   for (var i = 0; i < parsedEntryList.length; i++) {
  //     final entry = nearbyEntryList[i].data() as Map;
  //     String virtue = entry['quadrantUsed'];
  //     switch (virtue) {
  //       case 'Prudence':
  //         {
  //           chartData['Prudence'] = chartData['Prudence']! + 1;
  //         }
  //         break;

  //       case 'Self-control':
  //         {
  //           chartData['Self-control'] = chartData['Self-control']! + 1;
  //         }
  //         break;

  //       case 'Fairness':
  //         {
  //           chartData['Fairness'] = chartData['Fairness']! + 1;
  //         }
  //         break;

  //       case 'Integrity':
  //         {
  //           chartData['Integrity'] = chartData['Integrity']! + 1;
  //         }
  //         break;

  //       case 'Fidelity':
  //         {
  //           chartData['Fidelity'] = chartData['Fidelity']! + 1;
  //         }
  //         break;

  //       case 'Generosity':
  //         {
  //           chartData['Generosity'] = chartData['Generosity']! + 1;
  //         }
  //         break;

  //       case 'Compassion':
  //         {
  //           chartData['Compassion'] = chartData['Compassion']! + 1;
  //         }
  //         break;

  //       case 'Courage':
  //         {
  //           chartData['Courage'] = chartData['Courage']! + 1;
  //         }
  //         break;

  //       case 'Honesty':
  //         {
  //           chartData['Honesty'] = chartData['Honesty']! + 1;
  //         }
  //         break;
  //     }
  //   }

  //   return;
  // }

// // get nearby entries for nearby page ----IN PROGRESS----
//   Future<dynamic> getNearbyEntries(
//       String radius, String timeFrame, bool shareLocation) async {
//     final sharedCollectionRef =
//         FirebaseFirestore.instance.collection('CommunitySharedData');
//     final geoRef = geo.collection(collectionRef: sharedCollectionRef);

//     // convert radius string to double
//     String strRad = radius.replaceAll(new RegExp(r'[^0-9]'), '');
//     double numRadius = double.parse(strRad);

//     if (shareLocation) {
//       print('getting nearby entries');

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       GeoFirePoint geoFireLocation =
//           geo.point(latitude: position.latitude, longitude: position.longitude);

//       var stream = geoRef.within(
//           center: geoFireLocation,
//           radius: numRadius,
//           field: 'userLocation',
//           strictMode: true);

//       List<DocumentSnapshot> nearbyEntryList = [];

//       late StreamSubscription subscription;

//       subscription = stream.listen((List<DocumentSnapshot> documentList) {
//         for (var i = 0; i < documentList.length; i++) {
//           nearbyEntryList.add(documentList[i]);
//         }

//         parseNearbyEntries(nearbyEntryList, timeFrame);

//         return;
//       });
//     } else {
//       return "Location services not enabled";
//     }
//   }

//   Future<dynamic> findUsersNear() async {
//     // Target location
//     GeoPoint targetLocation = const GeoPoint(37.7749, -122.4194);
//     final double earthRadius = 6371; // Radius of the Earth in kilometers
//     double radiusInKm = 10;
//     // Convert radius from kilometers to degrees
//     double radiusInDegrees = radiusInKm / earthRadius;
//     double minLat = targetLocation.latitude - radiusInDegrees;
//     double maxLat = targetLocation.latitude + radiusInDegrees;
//     double minLon = targetLocation.longitude - radiusInDegrees;
//     double maxLon = targetLocation.longitude + radiusInDegrees;

//     GeoPoint max = new GeoPoint(maxLat, maxLon);
//     GeoPoint min = new GeoPoint(minLat, minLon);

//     print('Max: $max, min: $min');

// // Query documents within a certain radius
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('CommunitySharedData')
//         .where('userLocation', isLessThanOrEqualTo: max)
//         .where('userLocation', isGreaterThanOrEqualTo: min)
//         .get();
//   }

  Future<dynamic> getNotiTime() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }
      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc(user.uid).get();
      if (documentSnapshot.exists) {
        //final userInfo = documentSnapshot.data() as Map<String, dynamic>;
        dynamic notificationPreferences =
            documentSnapshot["notificationPreferences"];
        dynamic notiTime = notificationPreferences["notificationTime"];

        return {'Success': true, "response": notiTime};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'error': error.message};
    }
  }
}

final usersRepositoryProvider = Provider<Users>((ref) {
  return Users();
});
// final currentUserInfoProvider = StateProvider.autoDispose(
//     (ref) => ref.watch(usersRepositoryProvider).getUserInfo());
// final currentUserInfo =
//     StateProvider((ref) => ref.watch(usersRepositoryProvider).getUserInfo());
// final currentUserInfoProvider = StateProvider<Map<String, dynamic>>((ref) {
//   // This will call getUserInfo() once when the provider is first accessed
//   final dynamic userInfo = ref.watch(usersRepositoryProvider).getUserInfo();
//   return userInfo['response'] as Map<String, dynamic>? ??
//       {}; // Return response from getUserInfo(), or an empty map if it's null
// });
// final userInfoProvider = Provider<UserInfoe>((ref) {
//   // Return the UserInfo object here
//   final dynamic userInfo =
//       ref.watch(usersRepositoryProvider).getUserInfo().then((value) => {});
//   print(userInfo);
//   return UserInfoe(
//     id: '123',
//     email: 'user@example.com',
//     displayName: 'John Doe',
//     currentCommunity: 'Community A',
//     currentPosition: 'Developer',
//     careerLength: '3 years',
//   );
// });
final currentUserInfoProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final userInfo = await ref.read(usersRepositoryProvider).getUserInfo();
  return userInfo;
});

class _ChartData {
  _ChartData(this.x, this.y);

  String x;
  List y;
}
