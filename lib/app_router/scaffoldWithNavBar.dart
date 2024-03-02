import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/controllers/statsController.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(
    BuildContext context,
  ) {
    print('ScaffoldWithNavBar rebuild ${navigationShell.currentIndex}');
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Consumer(
        builder: (context, watch, child) {
          final currentIndex = navigationShell.currentIndex;

          return BottomNavigationBar(
            unselectedFontSize: 0,
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xff9C98C5),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            // Here, the items of BottomNavigationBar are hard coded. In a real
            // world scenario, the items would most likely be generated from the
            // branches of the shell route, which can be fetched using
            // `navigationShell.route.branches`.
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'Analysis'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.near_me), label: 'Nearby'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books), label: 'Resources'),
            ],
            currentIndex: currentIndex,
            onTap: (int index) => _onTap(context, index),
          );
        },
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(
    BuildContext context,
    int index,
  ) {
    print('from index: $index to: ${navigationShell.currentIndex}');
    switch (index) {
      case 0:
        {}
      case 1:
        {
          // ref
          //     .read(statsControllerProvider.notifier)
          //     .getQuadrantsUsedList("legal");
          // ref.read(statsControllerProvider.notifier).buildCalendar();
        }
      case 2:
        {}
      case 3:
        {}
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
