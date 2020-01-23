import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Configs {
  static final primaryColor = Colors.blueAccent;

  static final modalSheet = ModalBarrier(
    color: Colors.transparent,
    dismissible: false,
  );
  static final loader = SpinKitThreeBounce(
    size: 32.0,
    color: Colors.blueAccent,
    key: Key('app-loader'),
  );

  static TextStyle header5TextStyle = TextStyle(
      fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: 'Raleway');

  static TextStyle subtitle1Style = TextStyle(
      fontWeight: FontWeight.bold, fontFamily: 'Raleway', fontSize: 16);

  static TextStyle subtitle2Style = TextStyle(
      fontSize: 14, fontFamily: 'Raleway', fontWeight: FontWeight.bold);

  static InputDecoration getInputDecorationForTextField({String hint}) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(),
      ),
    );
  }

  static String validateText({String field, int length, String value}) {
    if (value == null) return "Invalid input";
    if (value.length < length)
      return "${field ?? "Input"} must be atleast $length characters long";
    return null;
  }

  static final formatter = new DateFormat('dd/MM/yyyy h:mm:ss a');

  static String getDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }

  /// getSearchableTagList & getSubSets
  /// these methods will be used for searching the item
  /// getSubSets will take a string as input and will return subsets of that string with minimum characters of 3
  static List<String> getSearchableTagList(List<String> tags) {
    // TODO: Implement
    return tags;
  }

  static List<String> getSubSets(String key) {
    //  TODO: implement
  }
}
