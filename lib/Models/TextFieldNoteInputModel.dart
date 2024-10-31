// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color inputTextColor = Color(0xFF000000);

Widget textFieldNoteInput(BuildContext context, TextEditingController controller, bool readOnly) 
{
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.0,
    height: 120,
    child: TextFormField(
      cursorColor: Colors.black,
      cursorRadius: const Radius.circular(0),
      controller: controller,
      maxLines: 4,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      readOnly: readOnly,
      style: GoogleFonts.tinos(
        textStyle: TextStyle(
          fontSize: 16,
          color: inputTextColor,
        ),
      ), 
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white
      ),
    )
  );
}
