import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class GridPagey extends StatefulWidget {
  final String appBarChoice;

  const GridPagey({super.key, required this.appBarChoice});

  @override
  State<GridPagey> createState() => _GridPageyState(appBarChoice: appBarChoice);
}

class _GridPageyState extends State<GridPagey> {
  List<dynamic>? quadrantList = [];
  final String appBarChoice;

  _GridPageyState({required this.appBarChoice});

  @override
  void initState() {
    super.initState();
    callGetQuadrantList();
  }

  Future<dynamic> callGetQuadrantList() async {
    final Communities communities = Communities();

    try {
      dynamic result = await communities.getQuadrantList("legal");
      if (result['Success']) {
        // user is authenticated in firebase authenctication
        // send to homepage
        setState(() {
          quadrantList = result['response'];
        });
      } else {
        print(result['Error']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(quadrantList);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
        appBar: AppBarWidget(appBarChoice),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              height: 740,
              child: Container(
                color: Color(0xFFFFFDF9),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Which virtue did you use today?',
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
                Expanded(
                    child: Container(
                  child: BuildGrid(listy: quadrantList),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuildGrid extends StatelessWidget {
  final List<dynamic>? listy;

  const BuildGrid({Key? key, this.listy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (listy ?? []).isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              final Map<String, dynamic> item =
                  listy![index] as Map<String, dynamic>;
              return Rectangle(
                quadrantName: item['quadrantName'],
                quadrantColor:
                    int.tryParse(item['quadrantColor'].toString()) ?? 0,
              );
            },
            itemCount: listy!.length,
          );
  }
}

// final quadrantListProvider = Provider((ref) => )
class GridPageTest extends ConsumerWidget {
  const GridPageTest({super.key});
  void getController(ref) {
    final controller = ref.watch(communitiesControllerProvider);
    controller.getQuadrantListy("legal");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listy = ref.watch(communitiesControllerProvider);
    final controller = ref.watch(communitiesControllerProvider);

    return controller.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (quadrantList) => BuildGrid(listy: quadrantList),
    );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle(
      {super.key, required this.quadrantName, required this.quadrantColor});

  final String quadrantName;
  final int quadrantColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: ElevatedButton(
            child: Text(
              //'WOOW',
              quadrantName,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Color(quadrantColor),
              // padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20,),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              shadowColor: Colors.black,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
