import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final auth = FirebaseAuth.instance;

  Future createAccount(email, password, fullName) async {
    print("called");
    try {
      if (email == null) {
        return Future.error({'Error': "Email is null"});
      }
      if (password == null) {
        return Future.error({'Error': "Password is null"});
      }

      final userCredentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //sendEmailVerification();
      return userCredentials.user;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future signInUser(String email, String password) async {
    if (email == null) {
      return Future.error({'Error': "Email is null"});
    }
    if (password == null) {
      return Future.error({'Error': "Password is null"});
    }
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return response;
    } catch (error) {
      return Future.error(error);
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

  // Working on, need to call this after user creates account in authentication.
  // This function creates user in the Users collection
  Future createNewUser(uid, fullName, displayName, email) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      final userCollectionRef = FirebaseFirestore.instance.collection('Users');
      try {
        final userObject = {"name": "linoln"};
        final newUser = await userCollectionRef.doc(uid).set(userObject);
      } catch (error) {
        return Future.error(error);
      }
    }
  }
}
