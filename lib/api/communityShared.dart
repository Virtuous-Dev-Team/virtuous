import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:latlong2/latlong.dart';

class CommunityShared {
  // Tested and finished, called by another function in users.dart
  Future<dynamic> addSharedVirtueEntry(
      virtueUsed, virtueColor, shareLocation, communityName) async {
    try {
      Users usersApi = Users();
      dynamic response = await usersApi.addUserLocation();
      GeoFirePoint updatedLocation;
      if (response['Success']) {
        updatedLocation = response['response'];
      } else {
        return {'Success': false, 'Error': 'Error getting user location'};
      }

      final double realLat = updatedLocation.coords.latitude;
      final double realLong = updatedLocation.coords.longitude;
      
      // randomize coordinates (based on longitudinal width of tile at highest zoom level (12): 0.088)
      // new location is randomized somewhere in a tile where the location would be the most zoomed in
      final bool addingToLong = Random().nextBool(); 
      final bool addingToLat = Random().nextBool();

      // 0.0396 is 45% and 0.01584 is 18% of tile width 
      final double longChange = Random().nextDouble() * (0.0396 - 0.01584) + 0.01584; 
      final double latChange = Random().nextDouble() * (0.0396 - 0.01584) + 0.01584;

      double randomLong;
      double randomLat;

      if(addingToLong) {
        randomLong = realLong + longChange;
      } else {
        randomLong = realLong - longChange;
      }

      if(addingToLat) {
        randomLat = realLat + latChange;
      } else {
        randomLat = realLat - latChange;
      }

      GeoFirePoint randomizedLocation = GeoFlutterFire().point(latitude: randomLat, longitude: randomLong);

      print('Location changed from ($realLat, $realLong) to ($randomLat, $randomLong)');


      // Expire date for Google Cloud TTL policies
      final DateTime now = DateTime.now();
      final DateTime date = DateTime(now.year, now.month, now.day);
      DateTime expireDate = date.add(const Duration(days: 30));

      String communityLookup = communityName.replaceAll(' ', '');

      // double realLong = updatedLocation.getLong
      final sharedEntry = {
        "dateEntried": FieldValue.serverTimestamp(),
        "expireDate" : expireDate,
        "userLocation": randomizedLocation.data,
        "communityName": communityLookup,
        "virtueName": virtueUsed
      };

      final communityRef = FirebaseFirestore.instance
        .collection('CommunitiesDemo')
        .doc(communityLookup);

      final collectionRef =
        communityRef
          .collection("Virtues")
          .doc(virtueUsed)
          .collection("sharedEntries");
      await collectionRef.add(sharedEntry);

      return {"Success": true, "response": "Submitted in shared database"};

    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print('Couldnt add shared virtue entry $error');
      return {'Success': false, 'Error': error};
    }
  }
}
