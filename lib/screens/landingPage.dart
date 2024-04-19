import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
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

class LandingPageTest extends ConsumerStatefulWidget {
  const LandingPageTest({super.key});

  @override
  _LandingPageTestState createState() => _LandingPageTestState();
}

class _LandingPageTestState extends ConsumerState<LandingPageTest> {
  @override
  void initState() {
    // Call your async method here
    navigate();
    // Future.microtask(() => setUserInfoProvider(ref));
    super.initState();
  }

  // late UserInfoProvider userInfoProvider;
  // final userInfoProviderr = ChangeNotifierProvider((ref) => UserInfoProvider());
  // setUserInfoProvider(ref) async {
  //   final setUserInfo = ref.read(userInfoProviderr);
  //   final getUserInfo = await ref.read(usersRepositoryProvider).getUserInfo();
  //   if (getUserInfo['Success']) {
  //     final info = getUserInfo['response'];
  //     setUserInfo.setUserInfo(getUserInfo['response']);
  //     print('landing page setting user info: ${setUserInfo.currentCommunity}');
  //   }
  // }

  Auth auth = Auth();
  Future<void> navigate() async {
    final user = auth.currentUser;
    if (user != null) {
      // Use GoRouter to navigate to the home page
      await Future.delayed(Duration.zero); // Ensure the build is complete
      final isNewUser = await getUserInfo();
      if (isNewUser['Success']) {
        await setUserInfoProvider(ref);
        // Future.microtask(() => setUserInfoProvider(ref));
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

setUserInfoProvider(ref) async {
  final setUserInfo = ref.read(userInfoProviderr);
  final getUserInfo = await ref.read(usersRepositoryProvider).getUserInfo();
  print('landinf page  ${getUserInfo['response']}');

  if (getUserInfo['Success']) {
    final info = getUserInfo['response'];
    setUserInfo.setUserInfo(getUserInfo['response']);
    print('landing page setting user info: ${setUserInfo.currentCommunity}');
  }
}
