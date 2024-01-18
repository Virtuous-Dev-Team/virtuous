import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/app_router/scaffoldWithNavBar.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/gridPage2.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/signUpPage.dart';

String initial(ref) {
  final user = ref.watch(authStateChangesProvider).value;
  print('User initial location function : $user');
  if (user != null) {
    // User is signed in, redirect to the home page
    return '/home';
  } else {
    // User is not signed in, redirect to the sign-in page
    return '/signIn';
  }
}

class AppNavigation {
  AppNavigation._();

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorAnalyze =
      GlobalKey<NavigatorState>(debugLabel: 'shellAnalyze');
  static final _shellNavigatorNearby =
      GlobalKey<NavigatorState>(debugLabel: 'shellNearby');
  static final _shellNavigatorResources =
      GlobalKey<NavigatorState>(debugLabel: 'shellResources');
  // GoRouter configuration

  // Call the navigation function after the build is complete
  // WidgetsBinding.instance?.addPostFrameCallback((_) => navigate());
  static final router = Provider<GoRouter>((ref) => GoRouter(
        initialLocation: initial(ref),
        debugLogDiagnostics: true,
        navigatorKey: _rootNavigatorKey,
        routes: [
          GoRoute(
            path: '/',
            name: 'LandingPage',
            builder: (context, state) => LandingPage(),
          ),
          GoRoute(
            path: '/signIn',
            name: 'signIn',
            builder: (context, state) => SignInPage(),
          ),
          GoRoute(
            path: '/signUp',
            name: 'signUp',
            builder: (context, state) => SignUpPage(),
          ),

          /// MainWrapper
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return ScaffoldWithNavBar(navigationShell: navigationShell);
            },
            branches: <StatefulShellBranch>[
              /// Brach Home
              StatefulShellBranch(
                navigatorKey: _shellNavigatorHome,
                routes: <RouteBase>[
                  GoRoute(
                    path: "/home",
                    name: "Home",
                    builder: (BuildContext context, GoRouterState state) =>
                        const HomePage(),
                    routes: [
                      GoRoute(
                        path: 'gridPage',
                        name: 'GridPage',
                        pageBuilder: (context, state) =>
                            CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const GridPage2(appBarChoice: 'arrow'),
                          transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Branch Analyze
              StatefulShellBranch(
                navigatorKey: _shellNavigatorAnalyze,
                routes: <RouteBase>[
                  GoRoute(
                    path: "/analysis",
                    name: "Analysis",
                    builder: (BuildContext context, GoRouterState state) =>
                        const AnalysisPage(),
                    routes: [],
                  ),
                ],
              ),

              // Branch Nearby
              StatefulShellBranch(
                navigatorKey: _shellNavigatorNearby,
                routes: <RouteBase>[
                  GoRoute(
                    path: "/nearby",
                    name: "Nearby",
                    builder: (BuildContext context, GoRouterState state) =>
                        const NearbyPage(),
                    routes: [],
                  ),
                ],
              ),

              /// Brach Resources
              StatefulShellBranch(
                navigatorKey: _shellNavigatorResources,
                routes: <RouteBase>[
                  GoRoute(
                    path: "/resource",
                    name: "Resources",
                    builder: (BuildContext context, GoRouterState state) =>
                        const ResourcePage(),
                    routes: [],
                  ),
                ],
              ),
            ],
          ),
        ],
      ));

  // // GoRouter configuration
  // static final GoRouter router = GoRouter(
  //   initialLocation: '/',
  //   debugLogDiagnostics: true,
  //   navigatorKey: _rootNavigatorKey,
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       name: 'LandingPage',
  //       builder: (context, state) => LandingPage(),
  //     ),
  //     GoRoute(
  //       path: '/signIn',
  //       name: 'signIn',
  //       builder: (context, state) => SignInPage(),
  //     ),
  //     GoRoute(
  //       path: '/signUp',
  //       name: 'signUp',
  //       builder: (context, state) => SignUpPage(),
  //     ),

  //     /// MainWrapper
  //     StatefulShellRoute.indexedStack(
  //       builder: (context, state, navigationShell) {
  //         return ScaffoldWithNavBar(navigationShell: navigationShell);
  //       },
  //       branches: <StatefulShellBranch>[
  //         /// Brach Home
  //         StatefulShellBranch(
  //           navigatorKey: _shellNavigatorHome,
  //           routes: <RouteBase>[
  //             GoRoute(
  //               path: "/home",
  //               name: "Home",
  //               builder: (BuildContext context, GoRouterState state) =>
  //                   const HomePage(),
  //               routes: [
  //                 GoRoute(
  //                   path: 'gridPage',
  //                   name: 'GridPage',
  //                   pageBuilder: (context, state) => CustomTransitionPage<void>(
  //                     key: state.pageKey,
  //                     child: GridPage(),
  //                     transitionsBuilder:
  //                         (context, animation, secondaryAnimation, child) =>
  //                             FadeTransition(opacity: animation, child: child),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),

  //         // Branch Analyze
  //         StatefulShellBranch(
  //           navigatorKey: _shellNavigatorAnalyze,
  //           routes: <RouteBase>[
  //             GoRoute(
  //               path: "/analysis",
  //               name: "Analysis",
  //               builder: (BuildContext context, GoRouterState state) =>
  //                   const AnalysisPage(),
  //               routes: [],
  //             ),
  //           ],
  //         ),

  //         // Branch Nearby
  //         StatefulShellBranch(
  //           navigatorKey: _shellNavigatorNearby,
  //           routes: <RouteBase>[
  //             GoRoute(
  //               path: "/nearby",
  //               name: "Nearby",
  //               builder: (BuildContext context, GoRouterState state) =>
  //                   const NearbyPage(),
  //               routes: [],
  //             ),
  //           ],
  //         ),

  //         /// Brach Resources
  //         StatefulShellBranch(
  //           navigatorKey: _shellNavigatorResources,
  //           routes: <RouteBase>[
  //             GoRoute(
  //               path: "/resource",
  //               name: "Resources",
  //               builder: (BuildContext context, GoRouterState state) =>
  //                   const ResourcePage(),
  //               routes: [],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ],
  // );
}
