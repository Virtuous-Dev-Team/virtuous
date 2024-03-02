import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/api/settings.dart';
import 'package:virtuetracker/api/stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/forgotPasswordPage.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/settings.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/settingsScreen/editprofile.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/tutorialPage.dart';
import 'package:virtuetracker/widgets/Calendar.dart';
import 'firebase_options.dart';
// Imported both pages from screens folder.
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
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
  final Settings settings = Settings();
  // await stats
  //     .getQuadrantsUsedList("legal")
  //     .then((value) => print('main: $value'));
  await stats
      .buildCalendar()
      .then((value) => print(value['response'].toString()));
}



// This widget has the navigation with routes
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final goRouter = ref.watch(goRouterProvider);
    final goRouter = ref.watch(AppNavigation.router);

   // /*
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Virtue Tacker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );

    // */
    /*
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: GridPage(), // closed for testing
      //home: SurveyPage(),
      //home: TutorialPage(),
      //home: SettingsPage(),
      // DONE settings, privacypolicy,termsofuse,
      // privacy, noti, changepass
    );

     */
  }
}
