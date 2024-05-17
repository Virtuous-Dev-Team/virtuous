import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';

import '../../App_Configuration/apptheme.dart';
import '../../widgets/appBarWidget.dart';

class ChangePhonePage extends StatefulWidget {
  // const SettingsPage({Key? key}) : super(key: key);

  @override
  _ChangePhonePageState createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneNumber.addListener(_formatPhoneNumberOnType);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
        appBar: AppBarWidget('regular'),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight / 1.2,
              decoration: BoxDecoration(
                color: Color(0xFFFFFDF9),
                border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                top: screenHeight / 50,
                bottom: screenHeight / 50,
                left: screenWidth / 30,
                right: screenWidth / 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
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
                            width: 2.0, // Set the border width
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextFormField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          onChanged: (newValue) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value!.length != 12)
                              return "Invalid phone number";
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: '123-456-7890',
                            hintStyle: GoogleFonts.tinos(
                                textStyle: TextStyle(color: Colors.black)),
                            border: InputBorder.none, // Hide the default border
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colours.swatch(clrBackground), // Dark purple color
                        borderRadius:
                            BorderRadius.circular(5), // Adjusted border radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 310,
                      height: 60,
                      child: Center(
                        child: Text(
                          "Update Phone Number",
                          style: GoogleFonts.tinos(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
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
        ));
  }

  void _formatPhoneNumberOnType() {
    final newValue = phoneNumber.text.replaceAll(RegExp(r'\D'), '');
    final formattedValue = _formatPhoneNumber(newValue);
    setState(() {
      phoneNumber.value = phoneNumber.value.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    });
  }

  String _formatPhoneNumber(String input) {
    if (input.length <= 3) {
      return input;
    } else if (input.length <= 6) {
      return '${input.substring(0, 3)}-${input.substring(3)}';
    } else {
      return '${input.substring(0, 3)}-${input.substring(3, 6)}-${input.substring(6, 10)}';
    }
  }
}
