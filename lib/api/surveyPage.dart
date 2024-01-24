import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

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
        appBar: AppBarWidget('regular'),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(),
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
          ),
        ),
        // Bottom Nav Bar goes here if needed
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
        Text('Let us get to know you.',
            style: Theme.of(context).textTheme.headline6),
        TextFormField(
          decoration: InputDecoration(labelText: 'What is your career?'),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'How long have you been in this career?'),
        ),
        DropdownButtonFormField<String>(
          value: 'Legal',
          items: <String>['Legal', 'Education', 'Technology', 'Healthcare']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: InputDecoration(labelText: 'Choose a community'),
        ),
        TextButton(
          child: Text('Learn more about communities.'),
          onPressed: () {},
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Please describe your reasons for joining Virtuous.'),
          maxLines: 5,
        ),
      ],
    );
  }
}

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Privacy', style: Theme.of(context).textTheme.headline6),
        DropdownButtonFormField<String>(
          value: 'No',
          items: <String>['Yes', 'No']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: InputDecoration(
              labelText: 'Would you like to participate in entry sharing?'),
        ),
        DropdownButtonFormField<String>(
          value: 'No',
          items: <String>['Yes', 'No']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: InputDecoration(
              labelText: 'Would you like to share your location?'),
        ),
      ],
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Notifications', style: Theme.of(context).textTheme.headline6),
        DropdownButtonFormField<String>(
          value: 'Yes',
          items: <String>['Yes', 'No']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: InputDecoration(labelText: 'Turn on notifications?'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Enter your phone number.'),
        ),
        DropdownButtonFormField<String>(
          value: 'Every day',
          items: <String>['Every day', 'Once a week', 'Never']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          decoration: InputDecoration(
              labelText:
                  'How often would you like to receive notifications from us?'),
        ),
        // Placeholder
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Select a time to receive notifications.'),
        ),
      ],
    );
  }
}
