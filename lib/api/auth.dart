import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final auth = FirebaseAuth.instance;

  Future<dynamic> createAccount(email, password, fullName) async {
    try {
      if (email == null) {
        return Future.error({'Error': "Email is null"});
      }
      if (password == null) {
        return Future.error({'Error': "Password is null"});
      }

      final userCredentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      createNewUser(userCredentials.user?.uid, fullName);
      //sendEmailVerification();
      return {'Success': true, 'response': userCredentials.user};
    } catch (error) {
      return Future.error({'Success': false, 'error': error});
    }
  }

  Future<dynamic> signInUser(String email, String password) async {
    if (email == null) {
      return Future.error({'Error': "Email is null"});
    }
    if (password == null) {
      return Future.error({'Error': "Password is null"});
    }
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return {'Success': true, "response": response};
    } catch (error) {
      return Future.error({'Success': false, 'Error': error});
    }
  }

  //  Working on
  Future sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return ("Verification email sent to ${user.email}");
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  // This function creates user in the Users collection
  // Haven't incorporated email verification
  Future createNewUser(
    uid,
    fullName,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    final userCollectionRef = FirebaseFirestore.instance.collection('Users');

    if (user != null) {
      try {
        final userObject = {
          "name": fullName,
          "currentCommunity": null,
          "userLocation": null,
          "reasons": [],
          "shareEntries": null,
        };

        final careerInfo = {"careerLength": null, "currentPosition": null};

        final notificationPreferences = {
          "allowNotifications": null,
          "notificationsTimes": [],
          "fcmToken": null
        };

        userObject["careerInfo"] = careerInfo;
        userObject["notificationPreferences"] = notificationPreferences;
        await userCollectionRef.doc(uid).set(userObject);

        await userCollectionRef.doc(uid).collection("totalData").add({});
      } catch (error) {
        return Future.error(error);
      }
    }
  }
}
