import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';

class Users {
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

  // Add different communities quadrant list, and write getter function per commmunity.

  final quadrantLists = {
    "legal": {
      "legal": {
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
    "other": {}
  };

  // Done,
  Future<dynamic> addVirtueEntry(currentCommunity, quadrantUsed, quadrantColor,
      quadrantAnswers, shareLocation) async {
    try {
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   return {'Success': false, 'Error': 'User not found'};
      // }
      final totalDataObject = {
        "communityName": currentCommunity,
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "dateEntried": FieldValue.serverTimestamp(),
        "quadrantAnswers": quadrantAnswers
      };
      // Add virtue entry to totalData subcollection
      await usersCollectionRef
          .doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2")
          .collection("totalData")
          .add(totalDataObject);

      // Maybe add a check to see if it completed
      await updateQuadrantsUsed(currentCommunity, quadrantUsed);
      print("unn");
      if (shareLocation) {
        final CommunityShared communitySharedApi = CommunityShared();
        await communitySharedApi
            .addSharedVirtueEntry(
                quadrantUsed, quadrantColor, shareLocation, currentCommunity)
            .catchError((e) => print(e));
      }
      return {'Success': true, "response": "Entry added"};
    } on FirebaseException catch (error) {
      print('Error ${error.message}');
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print(error);
    }
  }

  // Tested and is working as intended
  Future<dynamic> updateQuadrantsUsed(communityName, quadrantUsed) async {
    try {
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   return Future.error({'Success': false, 'Error': 'User not found'});
      // }

      // Increment whichever quadrant was used
      throw FirebaseException(plugin: "", message: "erorrrororror");
      await usersCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").update({
        'quadrantUsedData.${communityName}.${quadrantUsed}':
            FieldValue.increment(1),
      });
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
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
          .limit(5)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate over the documents
        dynamic recentEntriesList = querySnapshot.docs.map((document) {
          Timestamp timestamp = document['dateEntried'] as Timestamp;
          return {
            "communityName": document["communityName"],
            "quadrantUsed": document["quadrantUsed"] ?? "Error",
            "quadrantColor": document["quadrantColor"],
            "dateEntried": timestamp.toDate().toString(),
            "quadrantAnswers": document["quadrantAnswers"]
          };
        }).toList();

        // print(recentEntriesList);
        return {'Success': true, "response": recentEntriesList};
      } else {
        print('No documents found');
        return {'Success': false, 'Error': "Query is empty"};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'error': error.message};
    }
  }

  // Working, need to add phone number verification
  Future<dynamic> surveyInfo(currentPosition, careerLength, currentCommunity,
      reasons, shareEntries, shareLocation) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   return Future.error({'Success': false, 'Error': 'User not found'});
      // }
      final careerInfo = {
        "currentPosition": currentPosition,
        "careerLength": careerLength
      };

      dynamic userLocation;
      if (shareLocation) {
        dynamic res = await addUserLocation();
        if (res["Success"]) {
          print("User location acquired ${res["response"]}");
          userLocation = res["response"];
        } else {
          print("User location couldn't be acquired try again later");
        }
      }

      final userObject = {
        "currentCommunity": currentCommunity,
        "userLocation": userLocation,
        "reasons": reasons,
        "shareEntries": shareEntries,
        "shareLocation": shareLocation
      };
      final notificationPreferences = {
        "allowNotifications": null,
        "notificationsTimes": [],
        "fcmToken": null
      };
      userObject["careerInfo"] = careerInfo;
      userObject["notificationPreferences"] = notificationPreferences;
      userObject["quadrantUsedData"] = quadrantLists[currentCommunity];

      await usersCollectionRef
          .doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2")
          .set(userObject, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Used whenever we need to to ask for user permissions for location
  // Done and tested
  Future<dynamic> addUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error(
            {'Success': false, 'Error': 'Location services are disabled'});
      }

      print('Location services are enabled');

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('current $permission');
        if (permission == LocationPermission.denied) {
          return Future.error(
              {'Success': false, 'Error': 'Location permissions are denied'});
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission are denied until User changes it in settings, we can't request permission.
        return Future.error({
          'Success': false,
          'Error': 'Location permissions are denied permanently'
        });
      }

      print('Location services are allowed to check location');

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(
          "latitude: ${position.latitude} and longitude: ${position.longitude}");
      return {
        "Success": true,
        "response": GeoPoint(position.latitude, position.longitude)
      };
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Done and tested
  Future<dynamic> getUpdatedLocation(shareLocation) async {
    try {
      if (shareLocation) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        return GeoPoint(position.latitude, position.longitude);
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

      // if (user == null) {
      //   return Future.error({'Success': false, 'Error': "User not found"});
      // }
      print('called getUseriNFIO');
      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc(user?.uid).get();
      final userInfo = documentSnapshot.data() as Map<String, dynamic>;
      // print(userInfo);
      return {'Success': true, "response": userInfo};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> findUsersNear() async {
    // Target location
    GeoPoint targetLocation = GeoPoint(37.7749, -122.4194);

// Query documents within a certain radius
    double radiusInKm = 10.0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('location', isLessThanOrEqualTo: targetLocation)
        .where('location', isGreaterThanOrEqualTo: targetLocation)
        .get();
  }
}

final usersRepositoryProvider = Provider<Users>((ref) {
  return Users();
});
final currentUserInfo =
    StateProvider((ref) => ref.watch(usersRepositoryProvider).getUserInfo());
