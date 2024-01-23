import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Stats {
  final userCollectionRef = FirebaseFirestore.instance.collection("Users");

  Future<dynamic> getQuadrantsUsedList(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // if (user == null) {
      //   return {'Success': false, 'Error': "User not found"};
      // }

      DocumentSnapshot documentSnapshot =
          await userCollectionRef.doc("6EYIoEo5JDWB4akJGZ65D5YVzaM2").get();

      if (documentSnapshot.exists) {
        dynamic quadrantsUsedData = documentSnapshot["quadrantUsedData"];
        Map<String, int> quadrantsUsedList =
            Map<String, int>.from(quadrantsUsedData[communityName]);
        List<MapEntry<String, int>> sortedList =
            quadrantsUsedList.entries.toList();
        sortedList.sort((a, b) => a.value.compareTo(b.value));
        Map<String, int> sortedMap = Map.fromEntries(sortedList);
        Map<String, int> top3Map = Map.fromEntries(sortedList.take(3));
        // Get the bottom 3 entries
        Map<String, int> bottom3Map =
            Map.fromEntries(sortedList.skip(sortedList.length - 3));
        // Make an object for top 3 and bottom 3 and write method to sort them

        final response = {};
        response["quadrantUsedList"] = quadrantsUsedList;
        response["topThreeVirtues"] = top3Map;
        response["bottomThreeVirtues"] = bottom3Map;
        print(response);

        return {"Success": true, "response": response};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}
