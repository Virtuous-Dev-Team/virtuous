// ignore_for_file: prefer_const_constructors

import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import '../../widgets/appBarWidget.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';

class TermsOfUsePage extends StatefulWidget {
  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  String _TermsOfUse = '';

  @override
  void initState() {
    super.initState();
    _loadTermsOfUse();
  }

  Future<void> _loadTermsOfUse() async {
    final content = await rootBundle.loadString('assets/markdown/terms_of_service.md');
    setState(() {
      _TermsOfUse = content;
    });
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
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight / 50,
              horizontal: screenWidth / 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Terms of Service",
                    style: GoogleFonts.adamina(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 40),
                _TermsOfUse.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                      height: 500,
                      child: MarkdownWidget(
                          data: _TermsOfUse,
                          config: MarkdownConfig(
                            configs: [
                              PConfig(textStyle: TextStyle(fontSize: 16,color: Colors.black,),),
                            ],
                          ),
                        ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
