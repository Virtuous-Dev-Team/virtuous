import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtuetracker/api/users.dart';

class CommunityShared {
  // Tested and finished, called by another function in users.dart
  Future<dynamic> addSharedVirtueEntry(
      virtueUsed, virtueColor, shareLocation, communityName) async {
    try {
      Users usersApi = Users();
      dynamic response = await usersApi.addUserLocation();
      dynamic updatedLocation;
      if (response['Success']) {
        updatedLocation = response['response'];
      } else {
        return {'Success': false, 'Error': 'Error getting user location'};
      }

      final sharedEntry = {
        "dateEntried": FieldValue.serverTimestamp(),
        "userLocation": updatedLocation.data,
      };

      final collectionRef =
          FirebaseFirestore.instance.collection("CommunitiesDemo")
            .doc(communityName)
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
