import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:intl/intl.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:rxdart/rxdart.dart';
import '../data_models/countries.dart';
import 'package:flutter/cupertino.dart';

import 'configs.dart';

class PhoneAuthWidgets {
  static Widget getLogo({String logoPath, double height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath, height: height),
      );

  static Widget searchCountry(TextEditingController controller) => Padding(
        padding:
            const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
        child: Card(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Search your country',
                contentPadding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                border: InputBorder.none),
          ),
        ),
      );

  static Widget phoneNumberField(
          TextEditingController controller, String prefix) =>
      Card(
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.phone,
          key: Key('EnterPhone-TextFormField'),
          decoration: InputDecoration(
            border: InputBorder.none,
            errorMaxLines: 1,
            prefix: Text("  " + prefix + "  "),
          ),
        ),
      );

  static Widget selectableWidget(
          Country country, Function(Country) selectThisCountry) =>
      Material(
        color: Colors.white,
        type: MaterialType.canvas,
        child: InkWell(
          onTap: () => selectThisCountry(country), //selectThisCountry(country),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              "  " +
                  country.flag +
                  "  " +
                  country.name +
                  " (" +
                  country.dialCode +
                  ")",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );

  static Widget selectCountryDropDown(Country country, Function onPressed) =>
      Card(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(' ${country.flag}  ${country.name} ')),
                Icon(Icons.arrow_drop_down, size: 24.0)
              ],
            ),
          ),
        ),
      );

  static Widget subTitle(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(' $text',
          style: TextStyle(color: Colors.white, fontSize: 14.0)));
}

class MyWidgets {
  static void alertDialog(
      {BuildContext context,
      List<Widget> actions,
      Widget title,
      Widget content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              actions: actions,
              content: content,
              title: title,
              elevation: 8.0,
            )
          : CupertinoAlertDialog(
              actions: actions,
              content: content,
              title: title,
            ),
    );
  }

  static void dialog({BuildContext context, Widget content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: content,
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  static void errorDialog({BuildContext context, String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
              content: Text(message),
              title: Text('Error'),
              elevation: 8.0,
            )
          : CupertinoAlertDialog(
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
              content: Text(message),
              title: Text('Error'),
            ),
    );
  }

  //  For Tabs Screen
  static Widget getMenuTile(
      {Color color, String text, bool isSelected, Function onPressed}) {
    return InkWell(
      onTap: onPressed,
      splashColor: color,
      borderRadius: BorderRadius.circular(4.0),
      child: SizedBox(
        height: 50.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: color,
                decoration: isSelected
                    ? TextDecoration.underline
                    : TextDecoration.none),
          ),
        ),
      ),
    );
  }

  static Widget pickImageAndPresent({File image, Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getFormTitle(label: 'Preview'),
          SizedBox(height: 4.0),

          //  Pick image if image == null
          image == null
              ? CupertinoButton(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(4.0),
                  onPressed: onPressed,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.file_upload,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      SizedBox(width: 8.0),
                      Text('Please upload an image',
                          style: TextStyle(color: Colors.white, fontSize: 16.0))
                    ],
                  ),
                )
              : SizedBox(),

          image != null
              ? Image.file(
                  image,
                  fit: BoxFit.fill,
                  height: 250.0,
                  repeat: ImageRepeat.noRepeat,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  static Widget textField(
      {String hint,
      String label,
      Function(String) validator,
      Function(String) save,
      bool isObscure,
      int maxLines,
      String initialValue,
      TextEditingController controller,
      bool enabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller ?? null,
        initialValue: initialValue ?? null,
        enabled: enabled ?? true,
        validator: validator,
        toolbarOptions:
            ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
        obscureText: isObscure ?? false,
        onSaved: save,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint ?? ' ',
            labelText: label ?? ' ',
            alignLabelWithHint: true),
      ),
    );
  }

  static Widget getFormTitle({String label}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 14.0,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  static Widget textFieldWithTitleAndCardBackground(
      {String hint,
      String label,
      Function(String) validator,
      Function(String) save,
      bool isObscure,
      int maxLines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getFormTitle(label: label),
          SizedBox(height: 4.0),
          Material(
//            elevation: 1.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Colors.grey)),
            type: MaterialType.card,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                validator: validator,
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
                obscureText: isObscure ?? false,
                onSaved: save,
                maxLines: maxLines ?? 1,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: hint),
//              decoration: InputDecoration(
//                  //border: OutlineInputBorder(),
//                  hintText: hint ?? ' ',
//                  labelText: label ?? ' '),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget platformButton({String text, Function onPressed}) {
    return CupertinoButton(
      color: Colors.greenAccent,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(4.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
    /*
    return Platform.isWindows
        ? RaisedButton(
            color: Colors.indigo,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        : CupertinoButton(
            color: Colors.indigo,
            onPressed: onPressed,
            borderRadius: BorderRadius.circular(8.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );*/
  }

  static Widget getIconAddNewWidget({String mainCategory, IconData icon}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.indigo, size: 48.0),
        SizedBox(width: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add New Item',
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              mainCategory,
              style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  static Widget getAppBar({Function onBackPressed}) {
    return PreferredSize(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: onBackPressed,
                child: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size(double.infinity, 50.0),
    );
  }

  static Widget issueWidget(Issue issue) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${issue.title}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Expanded(child: Text('${issue.description.substring(0, 50)}')),
              ],
            ),
            SizedBox(height: 4.0),
            Text('Status: ${issue.status.toString().substring(7)}'),
            SizedBox(height: 4.0),
            Text(
                'Assigned admin id: ${issue.assignee_id == null ? 'Not Assigned' : issue.assignee_id}'),
            SizedBox(height: 4.0),
            Text(
                'Authority status: ${issue.authority_status.toString().substring(16)}'),
            SizedBox(height: 4.0),
            Text('Last updated: ${Configs.getDateTime(issue.last_updated)}'),
          ],
        ),
      ),
    );
  }

  static Widget titleContent(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(
            content,
            style: TextStyle(fontSize: 16.0),
          ),
          //Divider(color: Colors.grey,height: 16.0,thickness: 1.0,)
        ],
      ),
    );
  }
}

/// Copyright
/// Mohammad Fayaz(https://github.com/fayaz07/awesome_widgets)
///
// ignore: must_be_immutable
class TagsField extends StatefulWidget {
  Function(List<String>) onTagAdded;
  Function(List<String>) onTagRemoved;
  String label;
  bool tags;

  TagsField(
      {@required this.onTagAdded,
      @required this.onTagRemoved,
      this.label = "Add your tags",
      this.tags = true});

  @override
  _TagsFieldState createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  List<String> _tags = [];
  TextEditingController _controller = TextEditingController();

  PublishSubject<List<String>> _publishSubject = PublishSubject();

  @override
  void dispose() {
    _publishSubject.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 14.0,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4.0),
        StreamBuilder<List<String>>(
            stream: _publishSubject.stream,
            initialData: List<String>(),
            builder: (context, snapshot) {
              return Wrap(
                runSpacing: 4.0,
                spacing: 4.0,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: List.generate(_tags.length, (int i) {
                  return Material(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            ' ${_tags[i]} ',
                            style: TextStyle(color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              _tags.removeAt(i);
                              widget.onTagRemoved(_tags);
                              _publishSubject.sink.add(_tags);
                            },
                            child: Icon(
                              Icons.close,
                              size: 16.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
        SizedBox(height: 8.0),
        Material(
          type: MaterialType.card,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(color: Colors.grey)),
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  onPressed: () {
                    if (widget.tags) {
                      _controller.text.split(" ").forEach((String value) {
                        if (value != null && value.length > 0) {
                          if (!_tags.contains(value)) _tags.add(value);
                        }
                      });
                    } else {
                      String value = _controller.text;
                      if (value != null && value.length > 3) {
                        if (!_tags.contains(value)) _tags.add(value);
                      }
                    }
                    _controller.clear();
                    _publishSubject.sink.add(_tags);
                    widget.onTagAdded(_tags);
                  },
                  color: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Center(
                    child: Text('ADD',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .apply(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(width: 4.0)
            ],
          ),
        )
      ],
    );
  }
}

/// Copyright
/// Mohammad Fayaz(https://github.com/fayaz07/awesome_widgets)
// ignore: must_be_immutable
class SingleSelectionButton extends StatefulWidget {
  List<String> buttons;
  int selectedIndex = 0;

  SingleSelectionButton({this.buttons, this.selectedIndex = 0}) {
    assert(this.buttons != null);
    assert(this.buttons.length > 1);
    assert(this.selectedIndex < buttons.length);
  }

  @override
  _SingleSelectionButtonState createState() => _SingleSelectionButtonState();
}

class _SingleSelectionButtonState extends State<SingleSelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
//        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
//        alignment:  WrapAlignment.center,
        direction: Axis.horizontal,
        children: _getButtons(),
      ),
    );
  }

  List<Widget> _getButtons() {
    return List.generate(widget.buttons.length, (int i) {
      return widget.selectedIndex == i
          ? _selectedButton(i)
          : _unSelectedButton(i);
    });
  }

  Widget _selectedButton(int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.buttons[i],
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4.0),
          Icon(Icons.check_circle),
        ],
      ),
    );
  }

  Widget _unSelectedButton(int i) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.selectedIndex = i;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.buttons[i],
          style: TextStyle(
              color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
