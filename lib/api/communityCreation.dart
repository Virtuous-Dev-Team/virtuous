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

  // gets a list of virtue names in a given community
  Future getVirtueNames(String communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      
      String communityLookup = communityName.replaceAll(' ', '');
      List<String> virtueList = [];

      // Get doc for target community
      final QuerySnapshot<Map<String, dynamic>> communityDoc = 
        await communityRef
        .where('communityName', isEqualTo: communityLookup)
        .get();
      
      
      final virtueArray = 
        communityDoc.docs.first.data()['quadrantInformation'];

      for (var virtue in virtueArray) {
        // add virtuename to virtueList
        virtueList.add(virtue['quadrantName']!);
      }

      return {'Success': true, 'response': virtueList};
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } 
  } 

  // Adds basic community info to both collections in db
  Future createNewCommunity(
    String communityName, String communityDesc) async {
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

  // edit description about existing community
  Future editCommunityDesc(String currentCommunity, String communityDesc) async {
    try {
      String communityLookup = currentCommunity.replaceAll(' ', '');
      
      // grabbing uid from Communities collection
      final QuerySnapshot<Map<String, dynamic>> targetData = await communityRef
            .where('communityName', isEqualTo: currentCommunity)
            .get();
      
      final String communityId = targetData.docs.first.id;

      // updates document in community ref
      await communityRef.doc(communityId)
        .set({'descriptionOfCommunity': communityDesc}, SetOptions(merge: true));
      
      // updates document in shared ref
      await sharedRef.doc(communityLookup)
        .set({'description': communityDesc}, SetOptions(merge: true));

      return {'Success': true, 'response': 'Community description updated'};
    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Create new virtue
  Future createVirtue(
    String currentCommunity, String virtueName, String definition, String virtueColor) async {
    try {
      
      // get uid of target community 
      final QuerySnapshot<Map<String, dynamic>> communityDoc = await communityRef
            .where('communityName', isEqualTo: currentCommunity)
            .get();
      
      final targetData = communityDoc.docs.first.data();
      final String communityId = communityDoc.docs.first.id;
      var virtueArrayObject = [];

      // grabs current array storing map of each virtue 
      if (targetData['quadrantInformation'] != null) {
        virtueArrayObject = targetData['quadrantInformation'];
      }
      print('sup');
      virtueArrayObject.add({
        'quadrantColor': virtueColor,
        'quadrantDefinition': definition,
        'quadrantName': virtueName
      });

      // add to communities collection
      await communityRef.doc(communityId)
        .set({'quadrantInformation': virtueArrayObject}, SetOptions(merge: true));

      final String communityLookup = currentCommunity.replaceAll(' ', '');

      // add to shared data collection
      await sharedRef.doc(communityLookup)
        .collection('Virtues')
        .doc(virtueName)
        .set({
          'color': virtueColor,
          'definition': definition
        });
      
      return {'Success': true, 'response': 'Virtue added to database'};
    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Editing an existing virtue 
  Future editVirtueInfo(
    String currentCommunity, String currentVirtue, String? definition, String? virtueColor) async {
    try {
      String finalDef = '';
      String finalColor = '';
      if (definition != null) {
        finalDef = definition;
      }
      if (virtueColor != null) {
        finalColor = virtueColor;
      }

      // get uid of target community 
      final QuerySnapshot<Map<String, dynamic>> targetData = await communityRef
            .where('communityName', isEqualTo: currentCommunity)
            .get();
      
      final String communityId = targetData.docs.first.id;

      // grabs current array storing map of each virtue 
      var virtueArrayObject = 
        targetData.docs.first.data()['quadrantInformation'];

      // find index of target virtue
      int targetIndex = 0;
      for (var virtue in virtueArrayObject) {
        if (virtue['quadrantName'] == currentVirtue) {
          // check what values will be changed and break
          if (definition == '') {
            finalDef = virtue['quadrantDefinition'] ?? 'Definition error';
          } 

          if (virtueColor == '') {
            finalColor = virtue['quadrantColor'] ?? 'Color error';
          }
          break;
        }
        targetIndex++;
      }


      // Check if there was an error getting a value thats not being changed
      // abort if so
      if (finalDef == 'Definition error' || finalDef == '') {
        return {'Success': false, 'Error': 'Error getting virtue definition'};
      }
      if (finalColor == 'Color error' || finalColor == '') {
        return {'Success': false, 'Error': 'Error getting virtue color'};
      }

      virtueArrayObject.replaceRange(targetIndex, targetIndex + 1, [{
          'quadrantName': currentVirtue,
          'quadrantDefinition': finalDef,
          'quadrantColor': finalColor
      }]);

      // edit in communities collection
      await communityRef.doc(communityId)
        .set({'quadrantInformation': virtueArrayObject}, SetOptions(merge: true));

      String communityLookup = currentCommunity.replaceAll(' ', '');
      // edit in shared data subcollection
      await sharedRef.doc(communityLookup)
        .collection('Virtues')
        .doc(currentVirtue)
        .set({
          'color': finalColor,
          'definition': finalDef
        });
      
      
      return {'Success': true, 'response': 'Virtue edited in database'};
    } 
    on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}

// Provider to use CommunityCreation class in other files
final communityCreationProvider = Provider<CommunityCreation>((ref) {
  return CommunityCreation();
});


