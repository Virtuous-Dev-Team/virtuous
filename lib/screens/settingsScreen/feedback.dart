import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/Models/TextFieldNoteInputModel.dart';
import 'package:virtuetracker/controllers/userFeedbackController.dart';
import 'package:virtuetracker/api/userFeedback.dart';
import '../../widgets/appBarWidget.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  String _feedbackType = 'Bug Report';
  String _message = '';
  final List<String> _feedbackOptions = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'Other'
  ];

  TextEditingController _response = TextEditingController();

  // @override void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(userFeedbackControllerProvider.notifier);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void _submitForm() async {
      try {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final userFeedbackController = 
            ref.read(userFeedbackProvider);
          
          await userFeedbackController.sendFeedback(_feedbackType, _response.text);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback submitted successfully!')),
          );
        }
      } catch (e) {
        print('Error in feedback submission: $e');
      }
    }

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
            padding: EdgeInsets.symmetric(
              vertical: screenHeight / 50,
              horizontal: screenWidth / 30,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Feedback Type'),
                    value: _feedbackType,
                    items: _feedbackOptions.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _feedbackType = value;
                        });
                      }
                    },
                  ),
                  textFieldNoteInput(
                      context, _response, false, 'meaningfulAns'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      "Submit Feedback",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
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
    );
  }
}
