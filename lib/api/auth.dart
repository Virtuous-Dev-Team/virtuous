import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

        final quadrantUsedData = {};

        userObject["careerInfo"] = careerInfo;
        userObject["notificationPreferences"] = notificationPreferences;
        userObject["quadrantUsedData"] = quadrantUsedData;
        await userCollectionRef.doc(uid).set(userObject);

        await userCollectionRef.doc(uid).collection("totalData").add({});
      } catch (error) {
        return Future.error(error);
      }
    }
  }

  // --- google sign in ---
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final gSignIn = await FirebaseAuth.instance.signInWithCredential(credential);

    final user = FirebaseAuth.instance.currentUser;

    // want to call this function after checking if the uid is already in the Users collection
    // createNewUser(user?.uid, googleUser?.displayName);


    // Once signed in, return the UserCredential
    return gSignIn;
  }


  // --- facebook sign in ---
  // doesn't work rn cuz app is not approved by facebook
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final fbSignIn = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    final user = FirebaseAuth.instance.currentUser;

    // similar to google sign in, call after checking if uid alr exists in collction
    // createNewUser(user?.uid, ); 

    // Once signed in, return the UserCredential
    return fbSignIn;
  }

}
