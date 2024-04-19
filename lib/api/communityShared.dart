import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtuetracker/api/users.dart';

class CommunityShared {
  // Tested and finished, need to api doc
  Future<dynamic> addSharedVirtueEntry(
      quadrantUsed, quadrantColor, shareLocation, communityName) async {
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
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "userLocation": updatedLocation.data,
        "communityName": communityName
      };

      final communitySharedDataCollection =
          FirebaseFirestore.instance.collection("CommunitySharedData");
      await communitySharedDataCollection.add(sharedEntry);

      return {"Success": true, "response": "Submitted in shared database"};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      print('Couldnt add shared virtue entry $error');
      return {'Success': false, 'Error': error};
    }
  }
}
