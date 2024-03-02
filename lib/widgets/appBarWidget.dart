import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarWidget(this.appBarChoice, {Key? key}) : super(key: key);
  final String appBarChoice;
  void showToasty(String msg, bool success, BuildContext context) {
    ToastNotificationWidget toast = new ToastNotificationWidget();
    print('calling toast widget in app bar widget');
    toast.successOrError(context, msg, success);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authControllerProvider).when(
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) {
          Future.delayed(Duration.zero, () {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              dynamic errorType = error;
              if (errorType['Function'] == 'signOut')
                showToasty(errorType['msg'], false, context);
            });
          });
        },
        data: (response) {
          // print('going to sign in page, after signing out ');
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            GoRouter.of(context).go(response);
          });
        });
    return appBarChoice.compareTo('regular') == 0
        ? RegularAppBar(ref: ref)
        : AppBarWithArrow(
            ref: ref,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RegularAppBar extends StatelessWidget {
  const RegularAppBar({super.key, required this.ref});
  final dynamic ref;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor, // Replace with your desired color
      elevation: 0,
      actions: [
        PopOutMenuWidget(
          ref: ref,
        )
      ],
    );
  }
}

class AppBarWithArrow extends StatelessWidget {
  const AppBarWithArrow({super.key, required this.ref});
  final dynamic ref;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor, // Replace with your desired color
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: iconColor), // Customize this icon as needed
        onPressed: () {
          GoRouter.of(context).pop();
        },
      ),
      actions: [
        PopOutMenuWidget(
          ref: ref,
        )
      ],
    );
  }
}

class PopOutMenuWidget extends StatelessWidget {
  const PopOutMenuWidget({super.key, this.ref});
  final dynamic ref;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(0, 50),
      color: Color(0xff9C98C5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
      icon: Icon(Icons.account_circle,
          size: 30, color: iconColor), // Replace with your desired icon
      onSelected: (value) {
        if (value == 'signOut') {
          print('sign out plz');
          ref.read(authControllerProvider.notifier).signOut();
        } else if (value == 'settings') {
          GoRouter.of(context).go('/SettingsPage');
        }
        // TODO: Handle other menu items if needed
      },

      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'signOut',
          child: Center(child: Text('Sign Out')),
        ),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Center(child: Text('Settings')),
        ),

        // TODO: Add other menu items as needed
      ],
    );
  }

  // void _signOut(WidgetRef ref, BuildContext context) async {
  //   try {
  //     // final authService = ref.read(authRepositoryProvider);
  //     // print('user signing out');

  //     // await authService.signOutUser();
  //     // ref.read(AppNavigation.router).go('/signIn');

  //     ref.watch(authControllerProvider).when(
  //         loading: () => CircularProgressIndicator(),
  //         error: (error, stackTrace) {
  //           showToasty(error.toString(), false, context);
  //         },
  //         data: (response) {
  //           GoRouter.of(context).go('/signIn');
  //         });
  //   } catch (e) {
  //     print('Error signing out: $e');
  //   }
  // }
}
