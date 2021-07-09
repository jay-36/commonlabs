import 'package:flutter/material.dart';

ThemeData theme() {
  return  ThemeData(
      brightness: Brightness.dark,
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
    borderSide:
    BorderSide(color: Colors.grey, width: 1),
  );
  OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
    borderSide: BorderSide(color: Colors.teal, width: 3),
  );
  OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
    borderSide: BorderSide(color: Colors.red,width: 1),
  );
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
    borderSide: BorderSide(width: 1),
  );
  OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
    borderSide:
    BorderSide(color: Colors.red[700], width: 3),
  );
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
    enabledBorder: enabledBorder,
    focusedBorder: focusedBorder,
    errorBorder: errorBorder,
    focusedErrorBorder: focusedErrorBorder,
    border: border,
  );
}