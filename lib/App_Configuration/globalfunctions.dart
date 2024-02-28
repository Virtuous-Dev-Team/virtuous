import 'package:colours/colours.dart';
import 'package:flutter/material.dart';

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