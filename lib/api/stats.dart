import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/Models/LegalCalendarModel.dart';
import 'package:virtuetracker/Models/ChartDataModel.dart';

class Stats {
  final userCollectionRef = FirebaseFirestore.instance.collection("Users");

  Future<dynamic> getQuadrantsUsedList(communityName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      DocumentSnapshot documentSnapshot =
          await userCollectionRef.doc(user.uid).get();

      if (documentSnapshot.exists) {
        dynamic quadrantsUsedData = documentSnapshot["quadrantUsedData"];

        Map<String, int> quadrantsUsedList =
            Map<String, int>.from(quadrantsUsedData[communityName]);

        List<ChartData> charty = [];
        quadrantsUsedList.forEach((key, value) {
          double num = value.floorToDouble();
          charty.add(ChartData(key, num));
        });
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
        response["pieChart"] = charty;
        response["topThreeVirtues"] = top3Map;
        response["bottomThreeVirtues"] = bottom3Map;
        print(response);

        return {"Success": true, "response": response};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> buildCalendar() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      List<DateTime> HonestyDates = [];
      List<DateTime> CourageDates = [];
      List<DateTime> CompassionDates = [];
      List<DateTime> GenerosityDates = [];
      List<DateTime> FidelityDates = [];
      List<DateTime> IntegrityDates = [];
      List<DateTime> FairnessDates = [];
      List<DateTime> SelfControlDates = [];
      List<DateTime> PrudenceDates = [];

      QuerySnapshot querySnapshot = await userCollectionRef
          .doc(user.uid)
          .collection("totalData")
          .where('communityName', isEqualTo: 'legal')
          .get();
      // print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          // DocumentSnapshot documentSnapshot = element["dateEntried"];

          dynamic val = element.data();
          Timestamp dateEntried = val['dateEntried'];
          String virtueUsed = val["quadrantUsed"];
          // print(dateEntried.toDate());

          switch (virtueUsed) {
            case "Honesty":
              {
                HonestyDates.add(dateEntried.toDate());
              }
            case "Courage":
              {
                CourageDates.add(dateEntried.toDate());
              }
            case "Compassion":
              {
                CompassionDates.add(dateEntried.toDate());
              }
            case "Generosity":
              {
                GenerosityDates.add(dateEntried.toDate());
              }
            case "Fidelity":
              {
                FidelityDates.add(dateEntried.toDate());
              }
            case "Integrity":
              {
                IntegrityDates.add(dateEntried.toDate());
              }
            case "Fairness":
              {
                FairnessDates.add(dateEntried.toDate());
              }
            case "Self-control":
              {
                SelfControlDates.add(dateEntried.toDate());
              }
            case "Prudence":
              {
                PrudenceDates.add(dateEntried.toDate());
              }
          }
        });
        LegalCalendarModel model = LegalCalendarModel(
            CompassionList: CompassionDates,
            CourageList: CourageDates,
            FairnessList: FairnessDates,
            FidelityList: FidelityDates,
            GenerosityList: GenerosityDates,
            HonestyList: HonestyDates,
            IntegrityList: IntegrityDates,
            PrudenceList: PrudenceDates,
            SelfControlList: SelfControlDates);
        return {'Success': true, 'response': model};
        // dynamic totalData = querySnapshot['totalData'];
        // print(totalData);
      } else {
        return {'Success': false, 'Error': 'No entries in your account'};
      }
    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }
}

final statsRepositoryProvider = Provider<Stats>((ref) {
  return Stats();
});



// List<DateTime> SelfControlDates = [
//       DateTime(2024, 02, 22),
//       DateTime(2024, 02, 24),
//       DateTime(2024, 02, 26),
//     ];
//     calendarData.add(CalendarModel(
        // CompassionList: CompassionDates,
        // CourageList: CourageDates,
        // FairnessList: FairnessDates,
        // FidelityList: FidelityDates,
        // GenerosityList: GenerosityDates,
        // HonestyList: HonestyDates,
        // IntegrityList: IntegrityDates,
        // PrudenceList: PrudenceDates,
        // SelfControlList: SelfControlDates));
