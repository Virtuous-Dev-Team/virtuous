import 'dart:ui';
import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart';

List<String> careerDropdownValues = [
    'Legal',
    'Alcoholics Anonymous',
];

class LegalVirtueColors {
  static const Color primaryColor = Color(0xFF0A4BDA);
  static const Color secondaryColor = Color(0xFF7C83FD);
  static const Color accentColor = Color(0xFFFFA500);

  // Define more colors as needed
}

// Colors for Legal commmunity grid
Map<String, Color> legalVirtueColors = {
  'Honesty': Color(0xFFF3A3CA),
  'Courage': Color(0xFFCBF1D1),
  'Compassion': Color(0xFFB0E5F6),
  'Generosity': Color(0xFFF6EEA2),
  'Fidelity': Color(0xFFC58686),
  'Integrity': Color(0xFFFADAB4),
  'Fairness': Color(0xFFDEBFF5),
  'Self-control': Color(0xFF7AB0D8),
  'Prudence': Color(0xFF7FA881),
};

String clrHonesty = "#F3A3CA";
String clrCourage = "#CBF1D1";
String clrCompassion = "#B0E5F6";
String clrGenerosity = "#F6EEA2";
String clrFidelity = "#C58686";
String clrIntegrity = "#FADAB4";
String clrFairness = "#DEBFF5";
String clrSelfControl = "#7AB0D8";
String clrPrudence = "#7FA881";
String clrBlack = "#000000";
String clrBackground = "C5B898";
String clrWhite = "#FFFFFF";
String clrText = "#534D3F";
String clrPurple = '#9C98C5';

// Colors for Alcoholics Anonymous commmunity grid

final Map<String, Color> alAnVirtueColors = {
  "Honesty": Color(0xFF97AABD), // Pastel Blue
  "Hope": Color(0xFF9AD9DB), // Pastel Cyan
  "Surrender": Color(0xFFB39CD0), // Pastel Lavender
  "Courage": Color(0xFFDE9AA4), // Pastel Pink
  "Integrity": Color(0xFFB7D1A1), // Pastel Green
  "Willingness": Color(0xFFB0B5ED), // Pastel something, updated to be more different from the humility virtue
  "Humility": Color(0xFFF7E4AC), // Pastel Yellow
  "Love": Color(0xFFF5B4C6), // Pastel Rose
  "Responsibility": Color(0xFFE8CCB5), // Pastel Apricot
  "Discipline": Color(0xFFD4BFFF), // Pastel Purple
  "Awareness": Color(0xFFC4B7BB), // Pastel something, updated to be more different that the service virtue
  "Service": Color(0xFFB5EAD7), // Pastel Mint
};

Color? VirtueColor (String? communityName, String virtueName) {

  Color? color;
  switch (communityName) 
  {
    case "Legal":
      color = legalVirtueColors[virtueName];
      break;
    case "Alcoholics Anonymous":
      color = alAnVirtueColors[virtueName];
      break;
    default:
      color = Colors.red;
  }
  return color;

}

final Map<String, Map<String, String>> communityDefinitions = {

  "Legal": legalDefinitions,
  "Alcoholics Anonymous": alAnDefinitions

};


final Map<String, String> legalDefinitions = {
  'Honesty': "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
  'Courage': "Courage is the willingness to face fear, danger, or challenges with bravery and determination.",
  'Compassion': "Compassion is caring for others and wanting to help them when they are going through difficult times.",
  'Generosity': "Generosity is the act of giving or sharing with others, often without expecting anything in return.",
  'Fidelity': "Fidelity is faithfulness, loyalty, and the commitment to keeping promises and maintaining trust in a relationship or duty.",
  'Integrity': "Integrity is the practice of being honest and showing a consistent and uncompromising adherence to strong moral and ethical principles and values.",
  'Fairness': "Fairness is treating people justly, not letting your personal feelings bias your decisions about others. ",
  'Self-control': "Self-control is the ability to manage and restrain one's impulses, emotions, or actions in order to make deliberate and thoughtful choices.",
  'Prudence': "Prudence is the quality of making wise and cautious decisions by considering the potential consequences and risks.",
};

final Map<String, String> alAnDefinitions = {
  "Honesty": "Honesty - Being truthful with oneself and others, a foundational principle in AA for acknowledging and addressing the reality of addiction.",
  "Hope": "Hope - Believing in the possibility of recovery and a better future, providing motivation and optimism for those struggling with addiction.",
  "Surrender": "Surrender - Letting go of control and accepting one's powerlessness over alcohol, a vital step towards seeking help and embracing the AA program.)",
  "Courage": "Courage - Facing fears, uncertainties, and challenges associated with recovery, demonstrating resilience and determination in pursuing sobriety.",
  "Integrity": "Integrity - Maintaining moral and ethical principles, honesty, and consistency in actions, promoting trust and accountability within the AA community.",
  "Willingness": "Willingness - Having an open mind and readiness to accept help, guidance, and change, essential for personal growth and recovery in AA.",
  "Humility": "Humility - Recognizing one's limitations, acknowledging mistakes, and embracing a modest and teachable attitude towards recovery and spiritual growth.",
  "Love": "Love - Showing compassion, empathy, and support for fellow members, fostering a sense of community, connection, and belonging in AA. ",
  "Responsibility": "Responsibility - Taking ownership of one's actions, making amends, and actively participating in the recovery process, promoting accountability and self-improvement.",
  "Discipline":" Discipline - Adhering to the principles, practices, and commitments of the AA program, maintaining sobriety, and making positive lifestyle choices.",
  "Awareness": "Awareness - Being mindful of thoughts, feelings, and triggers related to alcohol use, cultivating self-awareness and self-control to prevent relapse and promote long-term recovery. ",
  "Service": " Service - Selflessly helping others within the AA community, contributing to the welfare and unity of the fellowship, and fostering a sense of purpose and fulfillment in recovery.",
};

String? virtueDef (String? communityName, String virtueName) {

  String? def;
  
  switch (communityName) 
  {
    case "Legal":
      def = legalDefinitions[virtueName];
      break;
    case "Alcoholics Anonymous":
      def = alAnDefinitions[virtueName];
      break;
    default:
      def = 'ERROR: communityName entered does not exist';
  }
  return def;
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
    MaterialState.selected
  };
  if (states.any(interactiveStates.contains)) {
    return Colours.blue;

  }
  else{
    return Colours.swatch('E7EAF0');
  }
//  return Colours.swatch('E7EAF0');
}


Map<String, Map<String, Color>> communityVirtueColors = {
  "Legal": {
    'Honesty': Color(0xFFF3A3CA),
    'Courage': Color(0xFFCBF1D1),
    'Compassion': Color(0xFFB0E5F6),
    'Generosity': Color(0xFFF6EEA2),
    'Fidelity': Color(0xFFC58686),
    'Integrity': Color(0xFFFADAB4),
    'Fairness': Color(0xFFDEBFF5),
    'Self-control': Color(0xFF7AB0D8),
    'Prudence': Color(0xFF7FA881),
  },
  "Alcoholics Anonymous": {
    "Honesty": Color(0xFF97AABD),
    "Hope": Color(0xFF9AD9DB),
    "Surrender": Color(0xFFB39CD0),
    "Courage": Color(0xFFDE9AA4),
    "Integrity": Color(0xFFB7D1A1),
    "Willingness": Color(0xFFB0B5ED),
    "Humility": Color(0xFFF7E4AC),
    "Love": Color(0xFFF5B4C6),
    "Responsibility": Color(0xFFE8CCB5),
    "Discipline": Color(0xFFD4BFFF),
    "Awareness": Color(0xFFC4B7BB),
    "Service": Color(0xFFB5EAD7),
  },

};



String formatTime(TimeOfDay timeOfDay) {
  // Use the format method of TimeOfDay to get a formatted string
  final now = DateTime.now();
  final dateTime = DateTime(
      now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat('h:mm a');
  return format.format(dateTime);
}

//This might be overkill, I(Reed) just wanted to get the distance in meters between two points give their longitude and latitude
//Got this from stack overflow
double distance(LatLng point1, LatLng point2) {
  const earthRadius = 6371000; 
  final lat1 = point1.latitude * pi / 180;
  final lon1 = point1.longitude * pi / 180;
  final lat2 = point2.latitude * pi / 180;
  final lon2 = point2.longitude * pi / 180;

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = pow(sin(dLat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double calculateClusterRadius(double zoomLevel) {
  double scaling = 3;
  return scaling * pow(2, (20 - zoomLevel)); 
}

String privacyPolicy = '';
