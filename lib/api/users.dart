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
  // Instance of Users collection from database
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

  // Instance of Firebase auth class to call Firebase methods
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";

  // Instance of GeoFlutterFire, class used for location services
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

  // // Quadrantlist for every community we have, used when a user changes to a new community
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
          };
        }).toList();

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

  // phone number verification, tested but couldn't work on some members computers
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

  // verify otp code, tested but couldn't work on some members computers
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
  }

  // updated to geoflutterfire
  Future<dynamic> addUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
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

  // Get entries for nearby feature
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

// Provider to use Users class in other files
final usersRepositoryProvider = Provider<Users>((ref) {
  return Users();
});

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
