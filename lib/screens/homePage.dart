import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/userControllers.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final response = ref
        .watch(UserRecentEntriesControllerProvider((communityName: "legal")));
    // final a = ref.watch(
    //     UserRecentEntriesController().getMostRecentEntries("communityName"));

    // print('testing homepage: $a');
    print('Fetching user recent entries ${response}');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
        appBar: AppBarWidget('regular'),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => {GoRouter.of(context).go('/home/gridPage')},
                  child: Text(
                    'Reflect',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    shape: CircleBorder(),
                    elevation: 4,
                    padding: EdgeInsets.all(70),
                  ),
                ),
                Text(' '),
                Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  // Builds list from response from api
                  child: response.when(
                      data: (recentEntriesList) =>
                          BuildRecentEntriesList(listy: recentEntriesList),
                      error: (error, stacktrace) => Text("Error: $error"),
                      loading: () => const CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildRecentEntriesList extends StatelessWidget {
  const BuildRecentEntriesList({super.key, required this.listy});
  final List<dynamic> listy;
  @override
  Widget build(BuildContext context) {
    print('Recent entries in HomePage: $listy');
    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Color(0xFFF3A3CA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(' '),
            ),
          ),
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              widthFactor: 2,
              child: Center(
                child: Text(
                  "Honesty",
                  maxLines: 1,
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(' '),
          ),
        ],
      ),
    );
  }
}
