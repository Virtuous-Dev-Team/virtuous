import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  @override
  SurveyPageState createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Text editing controllers for each TextField
  TextEditingController careerPosition = TextEditingController();
  TextEditingController careerLength = TextEditingController();
  TextEditingController reasons = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController notificationTime = TextEditingController();

  // Selected values for dropdowns
  String currentCommunity = 'Legal';
  String shareEntries = 'No';
  String shareLocation = 'No';
  String allowNotifications = 'No';

  String formattedPhoneNumber = '';

  // Dropdown values for each page
  List<String> careerDropdownValues = [
    'Legal',
    'Education',
    'Technology',
    'Healthcare'
  ];
  List<String> yesNoDropdownValues = ['Yes', 'No'];

  // List to store answers
  List<String> answers = ['', '', '', '', '', '', '', '', ''];

  bool _shouldShowContent = false;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    // Set initial values for text fields
    careerPosition.text = '';
    careerLength.text = '';
    reasons.text = '';
    phoneNumber.text = '';
    // phoneNumber.addListener(_formatPhoneNumberOnType);
    notificationTime.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 30, color: iconColor),
              onPressed: () {
                // TODO: Implement profile icon functionality.
              },
            ),
            SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      UserInfoPage(),
                      PrivacyPage(),
                      NotificationsPage(),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topCenter,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: buttonColor,
                          dotColor: mainBackgroundColor,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Let us get to know you.',
            style: GoogleFonts.tinos(
              textStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'What is your career?',
          style: GoogleFonts.tinos(
            textStyle: TextStyle(),
          ),
        ),
        SizedBox(
          height: 3,
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
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: 'Eg. lawyer',
              hintStyle:
                  GoogleFonts.tinos(textStyle: TextStyle(color: Colors.black)),
              border: InputBorder.none, // Hide the default border
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'How long have you been in this career?',
          style: GoogleFonts.tinos(
            textStyle: TextStyle(),
          ),
        ),
        SizedBox(
          height: 3,
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
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: 'Eg. 2 years',
              hintStyle:
                  GoogleFonts.tinos(textStyle: TextStyle(color: Colors.black)),
              border: InputBorder.none, // Hide the default border
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a community that best fits your reason for joining Virtuous.',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Learn more about communities.',
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    decoration: TextDecoration.underline, // Add underline
                    decorationColor: Color(0xFF534D3F),
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFCEC0A1),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 3,
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
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: 'Legal',
                  items: <String>[
                    'Legal',
                    'Education',
                    'Technology',
                    'Healthcare'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: GoogleFonts.tinos(textStyle: TextStyle()),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle dropdown value change
                  },
                  dropdownColor:
                      Colors.white, // Set the background color of the dropdown
                  isDense: true, // Reduce height
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.black), // Align the arrow to the right
                  isExpanded: true, // Extend the button to the right
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Please describe your reasons for joining Virtuous.',
          style: GoogleFonts.tinos(textStyle: TextStyle()),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter text...',
              hintStyle: GoogleFonts.tinos(textStyle: TextStyle()),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

/*
Future getLocation() async {
  await usersAPI.addUserLocation().then((value) => print(value));             UNCOMMENT
}

 */

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _shouldEntryShare = false;
  bool _shouldShareLocation = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Privacy',
            style: GoogleFonts.tinos(
              textStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Would you like to participate in entry sharing?',
          style: GoogleFonts.tinos(textStyle: TextStyle()),
        ),
        Text(
          'If you select "Yes," your data may be shown to other users. ssss',
          style: GoogleFonts.tinos(
            textStyle: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 53, 51, 47),
            ),
          ),
        ),
        SizedBox(
          height: 5,
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
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _shouldEntryShare ? 'Yes' : 'No',
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(value,
                              style: GoogleFonts.tinos(textStyle: TextStyle())),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _shouldEntryShare = newValue == 'Yes';
                    });
                  },
                  dropdownColor:
                      Colors.white, // Set the background color of the dropdown
                  isDense: true, // Reduce height
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.black), // Align the arrow to the right
                  isExpanded: true, // Extend the button to the right
                  underline: Container(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Would you like to share your location?',
          style: GoogleFonts.tinos(textStyle: TextStyle()),
        ),
        Text(
          'We will not share your location with other users.',
          style: GoogleFonts.tinos(
            textStyle: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFFCEC0A1),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _shouldShareLocation ? 'Yes' : 'No',
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: GoogleFonts.tinos(textStyle: TextStyle()),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _shouldShareLocation = newValue == 'Yes';
                    });
                  },
                  dropdownColor:
                      Colors.white, // Set the background color of the dropdown
                  isDense: true, // Reduce height
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.black), // Align the arrow to the right
                  isExpanded: true, // Extend the button to the right
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _shouldShowContent = false;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Notifications',
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Turn on notifications?',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFCEC0A1),
                  width: 2.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _shouldShowContent ? 'Yes' : 'No',
                      items: <String>['Yes', 'No']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            height: 30.0, // Adjust the height of each item
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                value,
                                style: GoogleFonts.tinos(
                                  textStyle: TextStyle(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          _shouldShowContent = newValue == 'Yes';
                        });
                      },
                      dropdownColor: Colors
                          .white, // Set the background color of the dropdown
                      isDense: true, // Reduce height
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.black), // Align the arrow to the right
                      isExpanded: true, // Extend the button to the right
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible:
                  _shouldShowContent, // Set this to true when 'Yes' is selected
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your phone number.',
                    style: GoogleFonts.tinos(
                      textStyle: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none, // Hide the default border
                        hintText: '(999)-999-9999',
                        hintStyle: GoogleFonts.tinos(
                            textStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /*
                  Text('How often would you like to receive notifications from us?',
                    style: GoogleFonts.tinos(
                      textStyle: TextStyle(
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: 'Every day',
                            items: <String>['Every day', 'Once a week', 'Never']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  height:
                                      30.0, // Adjust the height of each item
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(value, style: GoogleFonts.tinos(
                                  textStyle: TextStyle(),),),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Handle dropdown value change
                            },
                            dropdownColor: Colors
                                .white, // Set the background color of the dropdown
                            isDense: true, // Reduce height
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors
                                    .black), // Align the arrow to the right
                            isExpanded: true, // Extend the button to the right
                          ),
                        ),
                      ],
                    ),
                  ), //REMOVED for lincoln's request
                   */
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select a time to receive notifications.',
                    style: GoogleFonts.tinos(
                      textStyle: TextStyle(),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text(
                          'Select Time',
                          style: TextStyle(
                            color: Color(0xFFFFFDF9),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      selectedTime != null
                          ? 'Time Selected: ${selectedTime!.hourOfPeriod}:${selectedTime!.minute} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}'
                          : 'Time not selected',
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    // Change button color to beige
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _formatPhoneNumberOnType() {
    // final newValue = phoneNumber.text.replaceAll(RegExp(r'\D'), '');
    // final formattedValue = _formatPhoneNumber(newValue);
    // setState(() {
    //   // phoneNumber.value = phoneNumber.value.copyWith(
    //     // text: formattedValue,
    //     // selection: TextSelection.collapsed(offset: formattedValue.length),
    //   );
    // });
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        // answers[8] =
        //     '${selectedTime!.hour}:${selectedTime!.minute} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
        // notificationTime.text =
        //     '${selectedTime!.hour}:${selectedTime!.minute} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
      });
    }
  }
}
