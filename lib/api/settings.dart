import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:virtuetracker/api/noti_service.dart';

class Settings {
  // Instance of Firebase auth class to call Firebase methods
  final auth = FirebaseAuth.instance;

  // Instance of Users collection from database
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  static String verifyId = "";

  Future<dynamic> updatePassword(
      {required String newPassword, required Function authError}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      final response = await user.updatePassword(newPassword);
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

  Future<dynamic> updatePrivacy(
      bool newShareEntries, bool newShareLocation, dynamic userLocation) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      if (newShareLocation) {
        final response = await usersCollectionRef.doc(user.uid).update({
          'shareEntries': newShareEntries,
          'shareLocation': newShareLocation,
          'userLocation': userLocation
        });
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

  Future<dynamic> updateNotificationPreferences(
      bool newAllowNotifications, DateTime newNotificationTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      NotificationService notificationService = NotificationService();
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      // schedule notifications
      await notificationService.handleNotification(newAllowNotifications, newNotificationTime);

      await usersCollectionRef.doc(user.uid).update({
        'notificationPreferences.allowNotifications': newAllowNotifications,
        'notificationPreferences.notificationTime': newNotificationTime
      });

      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Re-authenticate the user with their email and password, sometimes when changing settings we have to reauthenticate
  Future<dynamic> reauthenticateUser(String email, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print('re-aunthenticating the user');
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return {"Success": true, 'response': "Done"};
      }
    } on FirebaseAuthException catch (e) {
      print('Error re-authenticating user: $e');
      return {'Success': false, 'Error': e.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  // Not using
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

// verify otp code, Not using
Future<dynamic> confirmOtp({
  required String otp,
  required String oldPhoneNumber,
}) async {
  final auth = FirebaseAuth.instance;
  final cred = PhoneAuthProvider.credential(
      verificationId: Users.verifyId, smsCode: otp);
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

// Provider to use Resources class in other files
final settingsRepositoryProvider = Provider<Settings>((ref) {
  return Settings();
});
