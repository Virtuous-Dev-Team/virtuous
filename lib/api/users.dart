import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

class Users {
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

  // Add different communities quadrant list, and write getter function per commmunity.
  final legalQuadrantList = {
    {
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
  };

  final quadrantLists = {
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
    },
    "other": {}
  };

  // Need to add to quadrantUsed
  Future<dynamic> addVirtueEntry(
      currentCommunity, quadrantUsed, quadrantColor, quadrantAnswers) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }
      final totalDataObject = {
        "communityName": currentCommunity,
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "dateEntried": FieldValue.serverTimestamp(),
        "quadrantAnswers": quadrantAnswers
      };
      await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .add(totalDataObject);

      DocumentSnapshot documentSnapshot = await usersCollectionRef.doc().get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;
      }

      return {'Success': true, "response": "Entry added"};
    } catch (e) {
      return Future.error({'Success': false, 'Error': e});
    }
  }

  Future<dynamic> updateQuadrantsUsed() async {
    // Get the current document data
    DocumentSnapshot userDocSnapshot =
        await usersCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").get();
    Map<String, dynamic> userData =
        userDocSnapshot.data() as Map<String, dynamic>;

    print(userData);
    // Check if the nested field exists and is a list
    if (userData.containsKey('quadrantUsedData')) {
      // Cast the list to a List<dynamic>
      dynamic list = userData['quadrantUsedData'];

      // Find the object in the list based on searchField and searchValue
      int index = list.indexWhere((obj) =>
          obj is Map<String, dynamic> && obj["communityName"] == "legal");

      // If the object is found, increment the specified field
      print(index);
      // if (index != -1) {
      //   list[index][fieldToIncrement] =
      //       (list[index][fieldToIncrement] ?? 0) + 1;

      //   // Update the document with the modified data
      //   await userDocRef.update({
      //     'nestedObject': list,
      //   });

      //   print(
      //       'Incremented nestedObject.$fieldToIncrement by 1 for user with ID $userId');
      // } else {
      //   print('Object not found in the list');
      // }
    } else {
      print('Nested structure not found or is not of the expected type');
    }
  }

  // In review
  Future<dynamic> getMostRecentEntries(communityName) async {
    try {
      QuerySnapshot querySnapshot = await usersCollectionRef
          .doc("aUhwKnnDDyfDE9YkIKxt2ep9zQE3")
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

  // Done but still need to review function used
  Future<dynamic> surveyInfo(currentPosition, careerLength, currentCommunity,
      reasons, shareEntries, shareLocation) async {
    final careerInfo = {
      "currentPosition": currentPosition,
      "careerLength": careerLength
    };
    final quadrantUsedData = {
      "communityName": currentCommunity,
      "quadrantsUsed": quadrantLists[currentCommunity]
    };
    User? user = FirebaseAuth.instance.currentUser;
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
    userObject["quadrantUsedData"] = quadrantUsedData;

    await usersCollectionRef
        .doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2")
        .set(userObject, SetOptions(merge: true));
  }

  // Update user's location in Firestore, needs review
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

  // Needs review
  Future<dynamic> getUpdatedLocation(shareLocation) async {
    try {
      // DocumentSnapshot documentSnapshot =
      //     await usersCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").get();
      // if (documentSnapshot.exists) {
      //   final shareLocation = documentSnapshot["shareLocation"];
      //   print(shareLocation);
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

  // Not finished
  Future<dynamic> addSharedVirtueEntry(
      quadrantUsed, quadrantColor, shareLocation) async {
    dynamic updatedLocation = await getUpdatedLocation(shareLocation)
        .catchError((e) => {print("no snsoa")});

    if (updatedLocation is GeoPoint) {
      print("true");
    } else {
      return (print("Not a GeoPoint"));
    }
    final sharedEntry = {
      "dateEntried": FieldValue.serverTimestamp(),
      "quadrantUsed": quadrantUsed,
      "quadrantColor": quadrantColor,
      "userLocation": ""
    };
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
}
