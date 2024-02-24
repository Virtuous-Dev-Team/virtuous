import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtuetracker/api/users.dart';

class CommunityShared {
  // Tested and finished, need to api doc
  Future<dynamic> addSharedVirtueEntry(
      quadrantUsed, quadrantColor, shareLocation, communityName) async {
    try {
      Users usersApi = Users();
      dynamic updatedLocation =
          await usersApi.getUpdatedLocation(shareLocation);

      final sharedEntry = {
        "dateEntried": FieldValue.serverTimestamp(),
        "quadrantUsed": quadrantUsed,
        "quadrantColor": quadrantColor,
        "userLocation": updatedLocation,
        "communityName": communityName
      };

      final communitySharedDataCollection =
          FirebaseFirestore.instance.collection("CommunitySharedData");
      await communitySharedDataCollection.add(sharedEntry);

      return {"Success": true, "response": "Submitted in shared database"};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (e) {
      print('Couldnt add shared virtue entry $e');
    }
  }
}
