import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/signInPage.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final user = ref.watch(authStateChangesProvider).value;
  //   print('User: $user');

  //   if (user != null) {
  //     // Use GoRouter to navigate to the home page
  //     // ref.read(goRouterProvider).go('signUp');
  //     GoRouter.of(context).go('/home');
  //     return Container(
  //       child: Text("helo"),
  //     );
  //   } else {
  //     // Use GoRouter to navigate to the sign-in page
  //     // ref.read(goRouterProvider).go('signIn');
  //     try {
  //       print("trying to go home");
  //       GoRouter.of(context).go('/home');
  //     } catch (e) {
  //       print('Error $e');
  //     }

  //     return Container(child: Text("helsssasaso"));
  //   }

  // }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    print('User: $user');

    Future<void> navigate() async {
      if (user != null) {
        // Use GoRouter to navigate to the home page
        await Future.delayed(Duration.zero); // Ensure the build is complete
        GoRouter.of(context).go('/home');
      } else {
        // Use GoRouter to navigate to the sign-in page
        await Future.delayed(Duration.zero); // Ensure the build is complete
        GoRouter.of(context).go('/signIn');
      }
    }

    // Call the navigation function after the build is complete
    WidgetsBinding.instance?.addPostFrameCallback((_) => navigate());

    return Container(
      child: Text("Hello"),
    );
  }
}
