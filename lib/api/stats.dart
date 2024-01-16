import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Stats {
  final userCollectionRef = FirebaseFirestore.instance.collection("Users");

  Future<dynamic> getQuadrantsUsedList(communityName) async {
    User? user = FirebaseAuth.instance.currentUser;

    // if (user == null) {
    //   return {};
    // }

    DocumentSnapshot documentSnapshot =
        await userCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").get();

    if (documentSnapshot.exists) {
      dynamic quadrantsUsedData = documentSnapshot["quadrantUsedData"];
      final quadrantsUsedList = quadrantsUsedData["legal"];

      // Make an ibject for top 3 and bottom 3 and write method to sort them
      print(quadrantsUsedList);
    }
  }
}
