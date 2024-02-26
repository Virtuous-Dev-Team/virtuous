import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:virtuetracker/api/users.dart';

class Settings {
  final auth = FirebaseAuth.instance;
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  static String verifyId = "";

  Future<dynamic> updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      final response = await user.updatePassword(newPassword);
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> updatePrivacy(
      bool newShareEntries, bool newShareLocation) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      if (newShareLocation) {
        Users userAPI = new Users();
        final getLocation = await userAPI.addUserLocation();
        if (getLocation['Success']) {
          final GeoPoint location = getLocation['response'];
          final response = await usersCollectionRef.doc(user.uid).update({
            'shareEntries': newShareEntries,
            'shareLocation': newShareLocation,
            'userLocation': location
          });
        } else {
          return {'Success': false, "Error": "Couldn't get location"};
        }
      } else {
        final response = await usersCollectionRef.doc(user.uid).update({
          'shareEntries': newShareEntries,
          'shareLocation': newShareLocation,
          'userLocation': null
        });
      }
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> updateProfile(String newEmail, String newProfileName,
      String newCareer, String newCommunity, String newCareerLength) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      // if (newEmail.isNotEmpty) {
      //   await user
      //       .verifyBeforeUpdateEmail(newEmail)
      //       .catchError((e) => print('error in updateProfile $e'));
      // }
      if (newProfileName.isNotEmpty) {
        await user
            .updateDisplayName(newProfileName)
            .catchError((e) => print('error in updateProfile $e'));
      } else {
        print('profile name is empty');
      }

      final response = await usersCollectionRef.doc(user.uid).update({
        'currentCommunity': newCommunity,
        'careerInfo.currentPosition': newCareer,
        'careerInfo.careerLength': newCareerLength
      });
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> updateNotificationPreferences(
      bool newAllowNotificationa, String newNotificationTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      final response = await usersCollectionRef.doc(user.uid).update({
        'notificationPreferences.allowNotifications': newAllowNotificationa,
        'notificationPreferences.notificationTime': newNotificationTime
      });
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> updatePhoneNumber({  
      required String newPhoneNumber,
      required Function errorStep,
      required Function nextStep,
    }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      await auth
        .verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: "+1$newPhoneNumber",
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

      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}
  // verify otp code
  Future<dynamic> confirmOtp({
    required String otp,
    required String oldPhoneNumber,
    }) async {

    final auth = FirebaseAuth.instance;
    final cred =
        PhoneAuthProvider.credential(verificationId: Users.verifyId, smsCode: otp);
    User? currentUser = await auth.currentUser!;

    // unlink the old phone number
    try {
      currentUser = await currentUser.unlink(oldPhoneNumber);
    } catch (e) {
      print(e);
      currentUser = await auth.currentUser!;
    }
    
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
  }

final settingsRepositoryProvider = Provider<Settings>((ref) {
  return Settings();
});
