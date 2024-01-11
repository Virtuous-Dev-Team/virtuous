// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Communities {
  Future getQuadrantList() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Future.error({'Success': false, 'Error': "User not found"});
      }
      final communityCollectionRef =
          FirebaseFirestore.instance.collection('Communities');
      final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

      DocumentSnapshot documentSnapshot =
          await usersCollectionRef.doc(user.uid).get();
      if (documentSnapshot.exists) {
        final usersCurrentCommunity = documentSnapshot["currentCommunity"];
      }

      // Query all documents in the community collection and search for specific community
      QuerySnapshot querySnapshot = await communityCollectionRef
          .where("communityName", isEqualTo: "legal")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Create a list of objects for grid Info with the specific quadrant name and color
        dynamic gridPageList =
            querySnapshot.docs.single['quadrantInformation'].map((doc) {
          return {
            'quadrantName': doc['quadrantName'] ?? 'Error',
            'quadrantColor': doc['quadrantColor'] ?? 'Error'
          };
        }).toList();
        // print(gridPageList);
        return {'Success': true, "response": gridPageList};
      } else {
        return Future.error({'Success': false, 'Error': "Query is empty"});
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
