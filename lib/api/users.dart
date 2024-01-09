import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Users {
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');

  Future<dynamic> addVirtueEntry(
      communityName, quadrantUsed, quadrantColor, quadrantAnswers) async {
    // User? user = FirebaseAuth.instance.currentUser;
    // QuerySnapshot querySnapshot = await usersCollectionRef
    //     .doc("aUhwKnnDDyfDE9YkIKxt2ep9zQE3")
    //     .collection("totalData")
    //     .where("quadrantUsed", isEqualTo: quadrantUsed)
    //     .where("communityName", isEqualTo: communityName)
    //     .get();

    // if (querySnapshot.docs.isNotEmpty) {
    //   // Iterate over each document in the QuerySnapshot
    //   for (QueryDocumentSnapshot document in querySnapshot.docs) {
    //     // Access data using the data() method
    //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //     // Print or use the data as needed
    //     print("Document ID: ${document.id}");
    //     print("Quadrant Used: ${data['quadrantUsed']}");
    //     print("Community Name: ${data['communityName']}");
    //     // Add more fields as needed
    //   }
    // } else {
    //   print("No documents found");
    // }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final totalDataObject = {
          "communityName": communityName,
          "quadrantUsed": quadrantUsed,
          "quadrantColor": quadrantColor,
          "dateEntried": FieldValue.serverTimestamp(),
          "quadrantAnswers": quadrantAnswers
        };
        await usersCollectionRef
            .doc(user.uid)
            .collection("totalData")
            .add(totalDataObject);
        return {'Success': true, "response": "Entry added"};
      } else {
        return Future.error({'Success': false, 'Error': 'User not found'});
      }
    } catch (e) {
      return Future.error({'Success': false, 'Error': e});
    }
  }

  Future<dynamic> getMostRecentEntries(communityName) async {
    try {
      QuerySnapshot querySnapshot = await usersCollectionRef
          .doc("aUhwKnnDDyfDE9YkIKxt2ep9zQE3")
          .collection("totalData")
          .where("communityName", isEqualTo: communityName)
          .orderBy('dateEntried', descending: true)
          .limit(5)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate over the documents
        dynamic recentEntriesList = querySnapshot.docs.map((document) {
          Timestamp timestamp = document['dateEntried'] as Timestamp;
          return {
            "quadrantUsed": document["quadrantUsed"] ?? "Error",
            "quadrantColor": document["quadrantColor"],
            "dateEntried": timestamp.toDate().toString(),
          };
        }).toList();

        print(recentEntriesList);
        return {'Success': true, "response": recentEntriesList};
      } else {
        print('No documents found');
        return Future.error({'Success': false, 'Error': "Query is empty"});
      }
    } catch (e) {
      return Future.error({'Success': false, 'Error': e});
    }
  }

  Future<dynamic> surveyInfo() async {
    final quadrantUsedData = {
      "communityName": "legal",
      "quadrantsUsed": {
        "Honesty": 0,
        "Courage": 0,
        "Compassion": 0,
        "Generosity": 0,
        "Fidelity": 0,
        "Integrity": 0,
        "Fairness": 0,
        "Self-control": 0,
        "Prudence": 0
      }
    };
  }
}
