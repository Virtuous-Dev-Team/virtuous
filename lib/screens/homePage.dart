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
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 15),
                Container(
                  // Builds list from response from api
                  child: response.when(
                      error: (error, stacktrace) => Text(
                            "You currently don't have any entries, click the Reflect button to make your first entry!",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                      data: (recentEntriesList) => BuildRecentEntriesList(
                          listy: recentEntriesList ?? []),
                      loading: () => const CircularProgressIndicator()),
                  // child: BuildRecentEntriesList(listy: []),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Builds recent entries list
class BuildRecentEntriesList extends StatelessWidget {
  const BuildRecentEntriesList({super.key, required this.listy});
  final List<dynamic> listy;
  @override
  Widget build(BuildContext context) {
    print('Recent entries in HomePage: $listy');

    return listy == null
        ? Center(
            child: Text('List is Null'),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: listy.length,
                itemBuilder: (BuildContext context, index) {
                  final Map<String, dynamic> item =
                      listy![index] as Map<String, dynamic>;
                  return RecentEntryWidget(
                      quadrantName: item['quadrantUsed'],
                      quadrantColor:
                          int.tryParse(item['quadrantColor'].toString()) ??
                              0xFFA6A1CC);
                }),
          );
  }
}

// Recent entrywidget, that is also tappable
class RecentEntryWidget extends StatelessWidget {
  const RecentEntryWidget(
      {super.key, required this.quadrantName, required this.quadrantColor});
  final String quadrantName;
  final int quadrantColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Clicked virtue');
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 1,
          ),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.center,
          // alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(quadrantColor),
                  ),
                  child: Text("")),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  quadrantName,
                  maxLines: 1,
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
