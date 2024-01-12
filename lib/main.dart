import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/gridPage2.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'firebase_options.dart';
// Imported both pages from screens folder.
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());

  // await Geolocator.openAppSettings();
  // await Geolocator.openLocationSettings();
  testingApi();
}

Future testingApi() async {
// Testing api

  final Communities c = Communities();
  final Users u = Users();
  final CommunityShared shared = CommunityShared();

  // Finished Testing addVirtue api
  // u
  //     .addVirtueEntry("legal", "Integrity", "quadrantColor",
  //         ["Answer 1", "Answer 2", "Answer 3sss", "Anserssssss"], true)
  //     .then((value) => {print(value["Success"])})
  //     .catchError((error) => {print(error)});

  // Finished Testing surveyInfo api
  // u.surveyInfo("best attorney ever in the world", "2 years", "legal",
  //     "I need to a", true, false);

  // await u
  //     .getUpdatedLocation(true)
  //     .then((value) => print(value))
  //     .catchError((e) => print(e));
  // u.addUserLocation().then((value) => print(value));
  shared
      .addSharedVirtueEntry("a", "a", true, "legal")
      .catchError((e) => print(e));
  // u.getUserLocation();
  // u.getMostRecentEntries("legal");
  dynamic userObject = await u.getUserInfo();
  // print(userObject);

  // u.updateQuadrantsUsed("legal", "Compassion");
  // Testing api ending
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // closed for testing
      //home: NavControllerPage(),
    );
  }
}
