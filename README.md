# VirtueTracker
This year we will be building a mobile application called Virtue Tracker. This application will mainly serve the legal industry and will give a user a chance to report what virtues they did or didn’t use. By using our app daily they will be able to observe their progress over time as we share their data and previous reports.

**Main Branch** - Should be for only tested code and production use

**Develop Branch** - Updated code that needs testing and will eventually be promoted to main branch. This code should be the most updated amoung the team.

**To run app:**
Clone repository and you should be on the main folder: Virtue Tracker
Step 0 (optional/recommended): You can open an mobile emulator
Step 1: flutter run

**To test screens** navigate to -> main.dart
Currently we are using GoRouter to handle our routes so we are automatically sent to either signIn or home. If you want to test a screen comment out the MyApp widget and uncomment the one above which will navigate to whichever screen you want.

**RiverPod controllers (api controllers)**
To create new controllers read this resource, we use a generator that will generate the AsyncNotifierProvider after saving the file. Link: https://codewithandrea.com/articles/flutter-riverpod-generator/

**Flutter packages** 
All flutter packages used can be found in pubsec.yaml, to look at their documentation you can search for the package here: https://pub.dev/

