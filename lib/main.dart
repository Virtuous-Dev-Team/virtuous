import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/api/settings.dart';
import 'package:virtuetracker/api/stats.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/forgotPasswordPage.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/changephone.dart';
import 'package:virtuetracker/screens/settingsScreen/settings.dart';
import 'package:virtuetracker/screens/dev/devsettings.dart';
import 'package:virtuetracker/screens/dev/editCommunityVirtues.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/editprofile.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/tutorialPage.dart';
import 'package:virtuetracker/screens/virtueEntry.dart';
import 'package:virtuetracker/widgets/Calendar.dart';
import 'firebase_options.dart';
// Imported both pages from screens folder.
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtuetracker/api/noti_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions( // for iOS?
    alert: true, 
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission( // for iOS?
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
              // other properties...
            ),
          ));
      }
  });

  runApp(
    ProviderScope(
      child: ChangeNotifierProvider(
        create: (_) =>
            UserInfoProvider(), // Provide an instance of UserInfoProvider
        child: MyApp(),
      ),
    ),
  );

  // testingApi();
}

Future testingApi() async {
// Testing api

  // final Communities c = Communities();
  // final Users u = Users();
  // final CommunityShared shared = CommunityShared();
  // final Stats stats = Stats();
  // final Auth auth = Auth();
  // final Settings settings = Settings();
}

// Test screens and widgets with this
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Virtue Tracker',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),

//         // routerConfig: AppRouter.router,
//         // home: HomePage(), // closed for testing
//         home: SurveyPage());
//   }
// }

// This widget has the navigation with routes
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final goRouter = ref.watch(goRouterProvider);
    final goRouter = ref.watch(AppNavigation.router);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      title: 'Virtue Tacker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
