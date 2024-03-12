import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

String formatTime(TimeOfDay timeOfDay) {
  // Use the format method of TimeOfDay to get a formatted string
  final now = DateTime.now();
  final dateTime = DateTime(
      now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat('h:mm a');
  return format.format(dateTime);
}

