import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

void main() => runApp(MaterialApp(
      home: RaiseIssue(),
      debugShowCheckedModeBanner: false,
    ));

class RaiseIssue extends StatefulWidget {
  @override
  _RaiseIssueState createState() => _RaiseIssueState();
}

class _RaiseIssueState extends State<RaiseIssue> {
  Issue issue = Issue();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 32.0),
                Text('Raise an issue',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700)),
                Text(
                    'Please note that you must be present at the spot while posting and issue so that your current location can be used as reference by the authorities',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 16.0,
                ),
                MyWidgets.textField(
                  label: 'Issue title',
                  hint: 'Ex: Sewage water issue',
                  save: (value) => issue.title = value,
                  validator: (value) => Configs.validateText(
                      field: 'Issue title', value: value, length: 5),
                ),
                MyWidgets.textField(
                  label: 'Issue Description',
                  hint: 'Ex: brief about the issue',
                  maxLines: 5,
                  save: (value) => issue.description = value,
                  validator: (value) => Configs.validateText(
                      field: 'Issue Description', value: value, length: 120),
                ),
                MyWidgets.textField(
                  label: 'Any old references(optional)',
                  hint: 'Ex: Tell us if the issue has also occured in the past',
                  maxLines: 5,
                  save: (value) => issue.old_references = value,
                  validator: (value) => null,
                ),
                pickLocationWidget(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  pickLocationWidget() {
    return FlatButton(
      onPressed: selectCurrentLocation,
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.my_location),
            SizedBox(width: 8.0),
            Text('Pick current location'),
          ],
        ),
      ),
    );
  }

  /// Location handling
  bool hasLocationPermission = false;
  var location = Location();
  var currLocation;

  void checkForPermissions() async {
    hasLocationPermission = await location.hasPermission();
    if (hasLocationPermission) {
      currLocation = await location.getLocation();
      print(
          "Current latlong: ${currLocation.latitude}, ${currLocation.longitude}");
    } else {
      requestLocationAccessPermission().then((permission) {
        if (permission)
          selectCurrentLocation();
        else
          showNoLocationPermissionDialog();
      });
    }
  }

  Future<bool> requestLocationAccessPermission() async {
    return location.requestPermission();
  }

  void showNoLocationPermissionDialog() {
    MyWidgets.alertDialog(
      context: context,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Text('RETRY', style: TextStyle(color: Colors.pink)),
            onTap: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
                requestLocationAccessPermission().whenComplete(() {
                  checkForPermissions();
                });
              });
            },
          ),
        )
      ],
      content: Text(
          'Your location settings have been disabled, please enable to continue'),
      title: Text('Permission denied'),
    );
  }

  void selectCurrentLocation() async {
    if (hasLocationPermission) {
      currLocation = await location.getLocation();
      print(currLocation.latitude);
      print(currLocation.longitude);
    } else {
      print('Requesting permissions');
      await location.requestPermission().then((value) {
        if (value) {
          location.getLocation().then((LocationData ld) async {
            print('Location : ${ld.latitude} ${ld.longitude}');
            issue.latitude = ld.latitude;
            issue.longitude = ld.longitude;

            List<Placemark> placemark = await Geolocator()
                .placemarkFromCoordinates(issue.latitude, issue.longitude);
            issue.address = placemark[0].locality;
            issue.postal_code = placemark[0].postalCode;
          });
        }
      });
    }
  }
}
