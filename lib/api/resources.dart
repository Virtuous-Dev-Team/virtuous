import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Resources {
  final communityCollectionRef =
  FirebaseFirestore.instance.collection('Communities');
  Future<dynamic> resourcesMyCommunityInfo(String communityName) async {
    try {
      QuerySnapshot querySnapshot = await communityCollectionRef
          .where("communityName", isEqualTo: communityName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<String> quadrantInfoList = [];
        querySnapshot.docs.single['quadrantInformation'].forEach((doc) {
          quadrantInfoList.add(doc['quadrantDefinition']);
        });

        final resourceList = {
          "communityDescription":
          querySnapshot.docs.single['descriptionOfCommunity'],
          "quadrantInfoList": quadrantInfoList
        };

        return {'Success': true, 'response': resourceList};
      } else {
        return {'Success': false, 'Error': "Query is empty"};
      }
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }
}

final resourcesRepositoryProvider = Provider<Resources>((ref) {
  return Resources();
});