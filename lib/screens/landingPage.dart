import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/signInPage.dart';

Users users = Users();

Future<dynamic> getUserInfo() async {
  final info = await users.getUserInfo();
  return info;
}

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);
  Future<void> navigate(user, context, ref) async {
    try {
      print(user);
      if (user != null) {
        // Use GoRouter to navigate to the home page
        await Future.delayed(Duration.zero); // Ensure the build is complete
        final isNewUser = await getUserInfo();
        if (isNewUser['Success']) {
          final goToSurveyPage = isNewUser['response']['currentCommunity'];
          print('isNewUser: ${goToSurveyPage}');
          if (goToSurveyPage == null) {
            print('needs to fill out survey');
            SchedulerBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(context).go('/survey');
            });
          } else {
            print('go to home page from landing page');
            // SchedulerBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go('/home');
            // });
          }
        }
      } else {
        // Use GoRouter to navigate to the sign-in page
        // await Future.delayed(Duration.zero); // Ensure the build is complete
        SchedulerBinding.instance.addPostFrameCallback((_) {
          GoRouter.of(context).go('/signIn');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final firstTime = ref.watch(accountCreatedProvider);
    print('User: $user');
    print('just created ${firstTime}');

    // Call the navigation function after the build is complete
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => navigate(user, context, ref));
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   navigate(user, context, ref);
    // });
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

class LandingPageTest extends StatefulWidget {
  const LandingPageTest({super.key});

  @override
  State<LandingPageTest> createState() => _LandingPageTestState();
}

class _LandingPageTestState extends State<LandingPageTest> {
  @override
  void initState() {
    // Call your async method here
    navigate();
    super.initState();
  }

  Auth auth = Auth();
  Future<void> navigate() async {
    final user = auth.currentUser;
    print(user);
    if (user != null) {
      // Use GoRouter to navigate to the home page
      await Future.delayed(Duration.zero); // Ensure the build is complete
      final isNewUser = await getUserInfo();
      if (isNewUser['Success']) {
        print('go to home page from landing page');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          GoRouter.of(context).go('/home');
        });
      } else {
        print('User has no record in Users collection so go to survey page');
        GoRouter.of(context).go('/survey');
      }
    } else {
      // Use GoRouter to navigate to the sign-in page
      // await Future.delayed(Duration.zero); // Ensure the build is complete
      SchedulerBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go('/signIn');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
