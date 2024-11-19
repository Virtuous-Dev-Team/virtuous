import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:virtuetracker/api/users.dart';

class UpdateProfile {
  // Instance of Firebase auth class to call Firebase methods
  final auth = FirebaseAuth.instance;

  // Instance of Users collection from database
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

  Future<dynamic> updateProfile(
      String newEmail,
      String newProfileName,
      String newCareer,
      String newCommunity,
      String newCareerLength,
      Function authError,
      bool newListExist) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      if (newEmail.isNotEmpty) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }
      if (newProfileName.isNotEmpty) {
        await user
            .updateDisplayName(newProfileName)
            .catchError((e) => print('error in updateProfile $e'));
      } else {
        print('profile name is empty');
      }
      // Build the update map
      final Map<String, dynamic> updateMap = {};
      if (newCommunity.isNotEmpty) {
        updateMap['currentCommunity'] = newCommunity;
        print('settings api profile $newListExist');
        if (newListExist == false) {
          // if changing community and hasnt been in the community before
          // create new list of virtue stats
          final Map<String, dynamic> userObject = {};
          userObject["quadrantUsedData"] = await Users().generateVirtueStats(newCommunity);

          await usersCollectionRef
              .doc(user.uid)
              .set(userObject, SetOptions(merge: true));
        }
      }
      if (newCareer.isNotEmpty) {
        updateMap['careerInfo.currentPosition'] = newCareer;
      }
      if (newCareerLength.isNotEmpty) {
        updateMap['careerInfo.careerLength'] = newCareerLength;
      }
      if (newProfileName.isNotEmpty) {
        await user
            .updateDisplayName(newProfileName)
            .catchError((e) => print('error in updateProfile $e'));
      } else {
        print('profile name is empty');
      }
      if (updateMap.isNotEmpty) {
        await usersCollectionRef.doc(user.uid).update(updateMap);
      }

      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      if (error.code == "requires-recent-login") {
        authError();
        return {'Success': false, 'Error': error.code};
      }
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

}

// Provider to use Resources class in other files
final updateProfileProvider = Provider<UpdateProfile>((ref) {
  return UpdateProfile();
});
