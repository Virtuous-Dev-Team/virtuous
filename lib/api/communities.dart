// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Communities {
  final communityCollectionRef =
      FirebaseFirestore.instance.collection('Communities');
  Future getQuadrantList(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   return {'Success': false, 'Error': "User not found"};
      // }

      // Query all documents in the community collection and search for specific community
      QuerySnapshot querySnapshot = await communityCollectionRef
          .where("communityName", isEqualTo: communityName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Create a list of objects for grid Info with the specific quadrant name and color
        dynamic gridPageList =
            querySnapshot.docs.single['quadrantInformation'].map((doc) {
          return {
            'quadrantName': doc['quadrantName'] ?? 'Error',
            'quadrantColor': doc['quadrantColor'] ?? 'Error',
            'quadrantDefinition': doc['quadrantDefinition'] ?? 'Error'
          };
        }).toList();
        // print(gridPageList);
        return {'Success': true, "response": gridPageList};
      } else {
        return {'Success': false, 'Error': "Query is empty"};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}

final communitiesRepositoryProvider = Provider<Communities>((ref) {
  return Communities();
});
