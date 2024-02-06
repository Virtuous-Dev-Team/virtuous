import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:virtuetracker/api/users.dart';
//import 'package:virtuetracker/widgets/appBarWidget.dart';     UNCOMMENT

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

Users usersAPI = new Users();

void main() => runApp(MaterialApp(home: SurveyPage()));

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBackgroundColor,
        //appBar: AppBarWidget('regular'),                 UNCOMMENT
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
        ), // PLACEHOLDER 4 ^^ DELETE ME
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
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Center(
          child: Text(
            'Let us get to know you.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'What is your career?',
        ),
        SizedBox(height: 3,),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: 'Enter text...',
              border: InputBorder.none, // Hide the default border
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'How long have you been in this career?',
        ),
        SizedBox(height: 3,),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: 'Enter text...',
              border: InputBorder.none, // Hide the default border
            ),
          ),
        ),
        SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a community that best fits your reason for joining Virtuous.',
            ),
            GestureDetector(
            onTap: () {},
            child: Text(
              'Learn more about communities.',
                style: TextStyle(
                  decoration: TextDecoration.underline, // Add underline
                  decorationColor: Color(0xFF534D3F),
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFCEC0A1),
                ),
              ),
            ),
          ],
        ),
    // Dropdown inside the Container with beige outline
         Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCEC0A1),
                width: 2.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: 'Legal',
                      items: <String>['Legal', 'Education', 'Technology', 'Healthcare']
                          .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(value),
                        ),
                      ),
                    );
                    }).toList(),
                    onChanged: (String? newValue) {
                    // Handle dropdown value change
                    },
                    dropdownColor: Colors.white, // Set the background color of the dropdown
                    isDense: true, // Reduce height
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Align the arrow to the right
                    isExpanded: true, // Extend the button to the right
                    ),
                  ),
              ],
            ),
        ),
        SizedBox(height: 40),
        Text(
          'Please describe yor reasons for joining Virtuous.',
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter text...',
              contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
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

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Center(
          child: Text(
            'Privacy',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Would you like to participate in entry sharing?',
        ),
        Text(
          'If you select "Yes," your data may be shown to other users.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color(0xFFCEC0A1),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: 'Yes',
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(value),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle dropdown value change
                  },
                  dropdownColor: Colors.white, // Set the background color of the dropdown
                  isDense: true, // Reduce height
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Align the arrow to the right
                  isExpanded: true, // Extend the button to the right
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Would you like to share your location?',
        ),
        Text(
          'We will not share your location with other users.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color(0xFFCEC0A1),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFCEC0A1),
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: 'Yes',
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        height: 30.0, // Adjust the height of each item
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(value),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle dropdown value change
                  },
                  dropdownColor: Colors.white, // Set the background color of the dropdown
                  isDense: true, // Reduce height
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Align the arrow to the right
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
  bool _shouldShowContent = false; // Declare _shouldShowContent here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Turn on notifications?',
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFCEC0A1),
                  width: 2.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(8.0),
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
                              child: Text(value),
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
                      dropdownColor: Colors.white, // Set the background color of the dropdown
                      isDense: true, // Reduce height
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Align the arrow to the right
                      isExpanded: true, // Extend the button to the right
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Visibility(
              visible: _shouldShowContent, // Set this to true when 'Yes' is selected
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Enter your phone number.'
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none, // Hide the default border
                          hintText: '(999)-999-9999'
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('How often would you like to receive notifications from us?'),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFCEC0A1),
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
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
                                  height: 30.0, // Adjust the height of each item
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(value),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Handle dropdown value change
                            },
                            dropdownColor: Colors.white, // Set the background color of the dropdown
                            isDense: true, // Reduce height
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Align the arrow to the right
                            isExpanded: true, // Extend the button to the right
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Select a time to receive notifications.'),
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text('Select Time', style: TextStyle(color: Color(0xFFFFFDF9),),),
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
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      print("Selected Time: ${selectedTime.format(context)}");
    }
  }
}