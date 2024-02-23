import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';

class Users {
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";

  // Add different communitiesst, and write getter function per commmunity.

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
      quadrantAnswers, shareLocation, shareEntries) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': 'User not found'};
      }
      final totalDataObject = {
        "communityName": currentCommunity,
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "dateEntried": FieldValue.serverTimestamp(),
        "quadrantAnswers": quadrantAnswers
      };
      // Add virtue entry to totalData subcollection
      await usersCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .add(totalDataObject);

      // Maybe add a check to see if it completed
      await updateQuadrantsUsed(currentCommunity, quadrantUsed);
      print("unn");
      if (shareLocation && shareEntries) {
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
          .limit(12)
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
          quadrantLists[currentCommunity.toLowerCase()] ?? 'Error';

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
        print("credential linked");
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
        print('current $permission');
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

      if (user == null) {
        return {'Success': false, 'Error': 'No user found'};
      }
      print('called getUseriNFIO');
      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc(user.uid).get();
      print('User Info snapshot: ${documentSnapshot.exists}');
      if (documentSnapshot.exists) {
        final userInfo = documentSnapshot.data() as Map<String, dynamic>;

        return {'Success': true, "response": userInfo};
      }
      return {'Success': false, "Error": 'User not found in Users collection'};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> findUsersNear() async {
    // Target location
    GeoPoint targetLocation = const GeoPoint(37.7749, -122.4194);
    final double earthRadius = 6371; // Radius of the Earth in kilometers
    double radiusInKm = 10;
    // Convert radius from kilometers to degrees
    double radiusInDegrees = radiusInKm / earthRadius;
    double minLat = targetLocation.latitude - radiusInDegrees;
    double maxLat = targetLocation.latitude + radiusInDegrees;
    double minLon = targetLocation.longitude - radiusInDegrees;
    double maxLon = targetLocation.longitude + radiusInDegrees;

    GeoPoint max = new GeoPoint(maxLat, maxLon);
    GeoPoint min = new GeoPoint(minLat, minLon);

    print('Max: $max, min: $min');

// Query documents within a certain radius
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CommunitySharedData')
        .where('userLocation', isLessThanOrEqualTo: max)
        .where('userLocation', isGreaterThanOrEqualTo: min)
        .get();
  }
}

final usersRepositoryProvider = Provider<Users>((ref) {
  return Users();
});
final currentUserInfo =
    StateProvider((ref) => ref.watch(usersRepositoryProvider).getUserInfo());
