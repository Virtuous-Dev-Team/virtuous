import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/api/stats.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/gridPage2.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/tutorialPage.dart';
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
  runApp(ProviderScope(child: MyApp()));

  // await Geolocator.openAppSettings();
  // await Geolocator.openLocationSettings();
  testingApi();
}

Future testingApi() async {
// Testing api

  final Communities c = Communities();
  final Users u = Users();
  final CommunityShared shared = CommunityShared();
  final Stats stats = Stats();
  final Auth auth = Auth();
  // Finished Testing addVirtue api
  u
      .addVirtueEntry("legal", "Courage", "quadrantColor",
          ["Answer 1", "Answer 2", "Answer 3sss", "Anserssssss"], true)
      .then((value) => {print(value["Success"])})
      .catchError((error) => {print('error in main: $error')});

  // Finished Testing surveyInfo api, need to add more
  // u.surveyInfo("best attorney ever in the world, even better than saul",
  //     "2 years", "legal", "I need to a", true, true);

  // await u
  //     .getUpdatedLocation(true)
  //     .then((value) => print(value))
  //     .catchError((e) => print(e));
  // u.addUserLocation().then((value) => print(value));
  // shared
  //     .addSharedVirtueEntry("a", "a", true, "legal")
  //     .catchError((e) => print(e));
  // u.getUserLocation();
  // u.getMostRecentEntries("legal");
  // dynamic userObject = await u.getUserInfo();
  // auth.signInWithGoogle();
  // print(userObject);

  // Tested and working
  // u.updateQuadrantsUsed("legal", "Compassion");
  // auth.signOutUser();

  // stats.getQuadrantsUsedList("legal");
  // Testing api ending
}

// Test screens and widgets with this
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // routerConfig: AppRouter.router,
      // home: HomePage(), // closed for testing
      home: SurveyPage(),
    );
  }
}

// This widget has the navigation with routes
// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final goRouter = ref.watch(goRouterProvider);
//     final goRouter = ref.watch(AppNavigation.router);

//     return MaterialApp.router(
//       routerConfig: goRouter,
//       title: 'Virtue Tacker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//     );
//   }
// }
