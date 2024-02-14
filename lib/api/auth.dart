import 'dart:io';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  final auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;
  Stream<User?> authStateChanges() => auth.authStateChanges();
  bool _accountCreated = false;
  bool get accountCreated => _accountCreated;
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
      dynamic result = await createNewUser(userCredentials.user?.uid, fullName);
      if (result['Success']) {
        print("Account created successfully");
        //sendEmailVerification();
        _accountCreated = true;
        return {'Success': true, 'response': userCredentials.user};
      }
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> signOutUser() async {
    try {
      await auth.signOut();
      return {'Success': true, 'response': "Signed out successfully"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  Future<dynamic> signInUser(String email, String password) async {
    if (email == null) {
      return {'Success': true, 'Error': "Email is null"};
    }
    if (password == null) {
      return Future.error({'Error': "Password is null"});
    }
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('sign in response: ${response.additionalUserInfo?.isNewUser}');
      // if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      //   // Update the state provider to indicate first-time sign-in
      //   context.read(isFirstTimeSignInProvider).state = true;
      // }

      return {'Success': true, "response": response};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
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
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // This function creates user in the Users collection
  // Haven't incorporated email verification
  Future<dynamic> createNewUser(
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
          "shareLocation": false
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

        // After creating the userObject in Users collection, we can add sub collection totalData
        await userCollectionRef.doc(uid).collection("totalData").add({});
        return {'Success': true};
      } on FirebaseAuthException catch (error) {
        return {'Success': false, 'Error': error.message};
      }
    }
  }

  Future verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // --- google sign in ---
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      print(credential);

      final gSignIn =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;

      // want to call this function after checking if the uid is already in the Users collection
      // createNewUser(user?.uid, googleUser?.displayName);

      print(gSignIn.credential);
      // Once signed in, return the UserCredential
      return gSignIn;
    } catch (e) {
      print('Error with google sign in: $e');
    }
  }

  // --- facebook sign in ---
  // doesn't work rn cuz app is not approved by facebook
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final fbSignIn = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    final user = FirebaseAuth.instance.currentUser;

    // similar to google sign in, call after checking if uid alr exists in collction
    // createNewUser(user?.uid, );

    // Once signed in, return the UserCredential
    return fbSignIn;
  }
}

// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final authRepositoryProvider = Provider<Auth>((ref) {
  return Auth();
});
final currentUserProvider = StateProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).currentUser);
final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).authStateChanges());
final accountCreatedProvider = StateProvider<bool>(
    (ref) => ref.watch(authRepositoryProvider).accountCreated);

// final isFirstTimeSignInProvider = StateProvider<bool>((ref) => false);
