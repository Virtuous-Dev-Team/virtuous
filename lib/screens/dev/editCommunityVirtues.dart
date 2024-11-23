import 'package:colours/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/communityCreation.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/settingsController.dart';
import 'package:virtuetracker/controllers/communityCreationController.dart';
import 'package:virtuetracker/controllers/communityController.dart';
import 'package:virtuetracker/controllers/userControllers.dart';
import 'package:virtuetracker/controllers/authControllers.dart';
import 'package:virtuetracker/controllers/statsController.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/dev/devsettings.dart';
import 'package:virtuetracker/screens/dev/editCommunityVirtues.dart';
import 'package:virtuetracker/main.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/virtueEntry.dart';
import 'package:virtuetracker/widgets/reauthenticateShowDialogWidget.dart';
import 'package:virtuetracker/widgets/toastNotificationWidget.dart';

import 'package:virtuetracker/widgets/createCommunityPopup.dart';
import 'package:virtuetracker/widgets/createVirtuePopup.dart';
import '../../widgets/appBarWidget.dart';
import '../settingsScreen/changepassword.dart';

class EditCommunityVirtuesPage extends ConsumerStatefulWidget {
  //const DevSettingsPage({super.key});
  final String? community;
  EditCommunityVirtuesPage(
      {super.key,
      required this.community
      });

  @override
  _EditCommunityVirtuesPageState createState() => _EditCommunityVirtuesPageState();
}

class _EditCommunityVirtuesPageState extends ConsumerState<EditCommunityVirtuesPage> {
  late String currentCommunity = widget.community!; //default to legal
  late String currentVirtue = '----Choose Virtue----'; //default to honesty in legal community

  final TextEditingController definitionController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityCreationControllerProvider.notifier).getVirtueNames(currentCommunity);
    });
  }

  @override
  Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  final communityProvider = ref.watch(communityCreationControllerProvider);

  return Scaffold(
    backgroundColor: Color(0xFFEFE5CC),
    appBar: AppBarWidget('regular'),
    body: SingleChildScrollView(
      child: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(
              top: screenHeight / 50,
              bottom: screenHeight / 25,
              left: screenWidth / 30,
              right: screenWidth / 30,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Community Virtue Settings",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        showCreateVirtueDialog(context, ref, currentCommunity);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colours.swatch(clrBackground),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: 210,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Create New Virtue",
                            style: GoogleFonts.tinos(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: 0,
                        maxHeight: screenHeight *
                            0.2), // Adjust the maxHeight according to your layout
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0, // Set the border width
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: communityProvider.when(
                        data: (data) {
                          print('virtue drop data: $data');
                          final List<String> virtuesDropValues = data['virtueList'];
                          virtuesDropValues.add('----Choose Virtue----');

                          print ('These are virtue drop values: $virtuesDropValues');

                          print('1: $currentVirtue');

                          return DropdownButton<String>(
                            value: currentVirtue,
                            onChanged: (newValue) {
                              setState(() {
                                currentVirtue = newValue!;
                                print('state changed : $currentVirtue');
                              });
                            },
                            items: virtuesDropValues.map<DropdownMenuItem<String>>((String value) {
                              print('Mapping dropdown item: $value');
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            isDense: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            isExpanded: true,
                            underline: Container(),
                            borderRadius: BorderRadius.circular(25.0),
                          );
                        },
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text("Error loading virtues"),
                      ),
                  ),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  // Remaining widgets for other sections
                  Text(
                    'Definition',
                    style: GoogleFonts.adamina(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      controller: definitionController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: 'Enter new definition for $currentVirtue',
                        hintStyle: GoogleFonts.tinos(
                            textStyle: TextStyle(color: Color.fromARGB(255, 122, 122, 122))),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  Text(
                    'Color Code',
                    style: GoogleFonts.adamina(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      controller: colorController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: 'Enter new color code for $currentVirtue',
                        hintStyle: GoogleFonts.tinos(
                            textStyle: TextStyle(color: Color.fromARGB(255, 122, 122, 122))),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                              final communityCreationController = 
                                ref.read(communityCreationProvider);

                              await communityCreationController
                                .editVirtueInfo(
                                  currentCommunity,
                                  currentVirtue,
                                  definitionController.text,
                                  colorController.text
                              );
                            } catch (e) {
                              print('Error in edit virtue $e');
                            }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colours.swatch(clrBackground),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: 210,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Update Virtue",
                            style: GoogleFonts.tinos(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

}
