import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// For Developer Use Only: 
// Creating and editing communities in one place to populate database with 
// necessary documents in both collections. 

class CommunityCreation {
  // Reference to Community resource collection
  final CollectionReference<Map<String, dynamic>> communityRef = 
    FirebaseFirestore.instance.collection("Communities");
  
  // Reference to Community shared entries collection
  final CollectionReference<Map<String, dynamic>> sharedRef = 
    FirebaseFirestore.instance.collection("CommunitiesDemo");

  Future getCommunityNames() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      List<String> commmunityList = [];

      // get all community docs
      final QuerySnapshot<Map<String, dynamic>> communityDocs = 
        await communityRef.get();

      for (final community in communityDocs.docs) {
        final communityData = community.data();

        commmunityList.add(communityData['communityName']);
      }

      return {'Success': true, "response": commmunityList};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }


  // Adds basic community info to both collections in db
  Future createNewCommunity(
    String communityName, String communityDesc, List<Map<String, String>>? virtues) async {
    try {
      String communityLookup = communityName.replaceAll(' ', '');
      final communityData = {
        'communityName': communityName,
        'descriptionOfCommunity': communityDesc
      };
      
      await communityRef.add(communityData);

      await sharedRef.doc(communityLookup).set({
        'communityName': communityName,
        'description': communityDesc
      });

      return {'Success': true, "response": "Community info added to db"};
    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // edit info about existing community
  Future editCommunityInfo(String? communityName, String? communityDesc) async {
    try {


    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Create new virtue
  Future createVirtue(String virtueName, String definition, String virtueColor) async {
    try {


    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Editing an existing virtue 
  Future editVirtueInfo(String? virtueName, String? definition, String? virtueColor) async {
    try {


    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}

// Provider to use Users class in other files
final communityCreationProvider = Provider<CommunityCreation>((ref) {
  return CommunityCreation();
});
