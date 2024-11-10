import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/Models/VirtueEntryModels.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

String? globalCommunityName;

class GridPage extends ConsumerStatefulWidget {
  const GridPage({super.key, required this.appBarChoice});
  final String appBarChoice;
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends ConsumerState<GridPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    communityName = userInfo.currentCommunity;
    globalCommunityName = communityName;
  }

  String communityName = '';
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(communitiesControllerProvider(
        (communityName: communityName)));

    return Scaffold(
      backgroundColor: Color(0xFFEFE5CC),
      appBar: AppBarWidget(widget.appBarChoice),
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
                child: controller.when(
                  loading: () => CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                  data: (quadrantList) => BuildGrid(
                    listy: quadrantList,
                  ),
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class BuildGrid extends StatelessWidget {
  final List<dynamic>? listy;

  const BuildGrid({Key? key, this.listy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(listy);
    return (listy ?? []).isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              final Map<String, dynamic> item =
                  listy![index] as Map<String, dynamic>;
              return Rectangle(
                key: Key('rectangle_${item['quadrantName']}'),
                quadrantName: item['quadrantName'],
                quadrantColor:
                    int.tryParse(item['quadrantColor'].toString()) ?? 0,
                quadrantDefinition: item['quadrantDefinition'],
              );
            },
            itemCount: listy!.length,
          );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle(
      {super.key,
      required this.quadrantName,
      required this.quadrantColor,
      required this.quadrantDefinition});

  final String quadrantName;
  final int quadrantColor;
  final String quadrantDefinition;

  @override
  Widget build(BuildContext context) {
    final Color? entryColor;
    entryColor = VirtueColor(globalCommunityName, quadrantName);
    
    return AspectRatio(
      aspectRatio: 1.0, // Maintain a 1:1 aspect ratio (adjust as needed)
      child: Container(
        width: 100.0, // Set a fixed width for the button
        child: ElevatedButton(
          onPressed: () {
            // ADD ME!!!
            GoRouter.of(context).goNamed('VirtueEntryPage', pathParameters: {
              'quadrantName': quadrantName,
              'quadrantDefinition': quadrantDefinition,
              'quadrantColor': quadrantColor.toString(),
            });
          },
          child: FractionallySizedBox(
            widthFactor: 2,
            child: Center(
              child: Text(
                quadrantName,
                maxLines: 1,
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: entryColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}
