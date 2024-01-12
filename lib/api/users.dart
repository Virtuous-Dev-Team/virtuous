import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
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
      //   return Future.error({'Success': false, 'Error': 'User not found'});
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

      if (shareLocation) {
        final CommunityShared communitySharedApi = CommunityShared();
        await communitySharedApi
            .addSharedVirtueEntry(
                quadrantUsed, quadrantColor, shareLocation, currentCommunity)
            .catchError((e) => print(e));
      }
      return {'Success': true, "response": "Entry added"};
    } catch (e) {
      return Future.error({'Success': false, 'Error': e});
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
      await usersCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").update({
        'quadrantUsedData.${communityName}.${quadrantUsed}':
            FieldValue.increment(1),
      });
    } catch (error) {
      return Future.error({'Success': false, 'Error': error});
    }
  }

  // Done
  Future<dynamic> getMostRecentEntries(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }
      QuerySnapshot querySnapshot = await usersCollectionRef
          .doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2")
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
            "quadrantUsed": document["quadrantUsed"] ?? "Error",
            "quadrantColor": document["quadrantColor"],
            "dateEntried": timestamp.toDate().toString(),
          };
        }).toList();

        print(recentEntriesList);
        return {'Success': true, "response": recentEntriesList};
      } else {
        print('No documents found');
        return Future.error({'Success': false, 'Error': "Query is empty"});
      }
    } catch (e) {
      return Future.error({'Success': false, 'Error': e});
    }
  }

  // Done but still need to review function used, and check for users
  Future<dynamic> surveyInfo(currentPosition, careerLength, currentCommunity,
      reasons, shareEntries, shareLocation) async {
    final careerInfo = {
      "currentPosition": currentPosition,
      "careerLength": careerLength
    };

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Future.error({'Success': false, 'Error': 'User not found'});
    }
    final userObject = {
      "currentCommunity": currentCommunity,
      "userLocation": shareLocation == true ? await addUserLocation() : null,
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
      return GeoPoint(position.latitude, position.longitude);
    } catch (e) {
      print('Error updating location: $e');
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
    } catch (error) {
      print(error);
      return Future.error({'Success': false, 'Error': error});
    }
  }

  // Done
  Future<dynamic> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // if (user == null) {
      //   return Future.error({'Success': false, 'Error': "User not found"});
      // }

      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").get();
      final userInfo = documentSnapshot.data() as Map<String, dynamic>;
      // print(userInfo);

      return {'Success': true, "response": userInfo};
    } catch (error) {
      return Future.error({'Success': false, 'Error': error});
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
