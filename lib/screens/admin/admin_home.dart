import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/admin.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/login/splash.dart';
import 'package:public_issue_reporter/providers/admin/admin_provider.dart';
import 'package:public_issue_reporter/screens/admin/add_locality.dart';
import 'package:public_issue_reporter/screens/admin/complete_profile.dart';
import 'package:public_issue_reporter/screens/admin/view_admins.dart';
import 'package:public_issue_reporter/screens/admin/view_issues.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/session_data.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

import 'view_localities.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Admin.getAdminData().then((Result result) {
      if (result.success) {
        Provider.of<AdminProvider>(context, listen: false).admin = result.data;
        SessionData.adminData = result.data;
      } else
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => CompleteProfile()));
      _hideLoader();
    }).catchError((error) {
      MyWidgets.errorDialog(context: context, message: error.toString());
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Home'),
      ),
      body: Stack(
        children: <Widget>[
          _getBody(adminProvider),
          _isLoading ? Configs.modalSheet : SizedBox(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  String adminMainWork =
      'You will have access to add localities for your area and assign authority to handle issues for that locality as well track the performance of authorities, track issues';

  Widget _getBody(AdminProvider adminProvider) {
    return SafeArea(
      child: adminProvider.admin.uid != null
          ? SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text('Welcome', style: TextStyle(fontSize: 16.0)),
                      Text(
                        adminProvider.admin.name,
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                          adminProvider.admin.admin_type == AdminType.Main
                              ? adminMainWork
                              : '',
                          style: TextStyle(fontSize: 14.0)),
                      SizedBox(height: 16.0),
                      (adminProvider.admin.admin_type == AdminType.Main
                          ? _forMainAdmin()
                          : _forLocalityAdmin()),
                      SizedBox(height: 32.0),
                      Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.power_settings_new),
                              SizedBox(width: 8.0),
                              Text(
                                'Log out',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          onPressed: () {
                            FireBase.auth.signOut().then((r) {
                              Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          SplashScreen()));
                            });
                          },
                        ),
                      )
                    ],
                  )),
            )
          : (_isLoading
              ? SizedBox()
              : Center(
                  child: Text('Something has gone wrong'),
                )),
    );
  }

  Widget _forMainAdmin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => ViewIssues()));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View Issues',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => ViewAdmins()));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View Admins',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => ViewLocalities()));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View Localities',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => AddLocality()));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'Add Locality',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _forLocalityAdmin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.redAccent,
                onPressed: () {
                  if (SessionData.adminData.locality_id == null ||
                      SessionData.adminData.locality_id.length < 2) {
                    MyWidgets.errorDialog(
                        context: context,
                        message: 'You have not assigned to any locality');
                  }
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          ViewIssues(status: Status.Solved)));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View solved issues',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blueAccent,
                onPressed: () {
                  if (SessionData.adminData.locality_id == null ||
                      SessionData.adminData.locality_id.length < 2) {
                    MyWidgets.errorDialog(
                        context: context,
                        message: 'You have not assigned to any locality');
                  }
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          ViewIssues(status: Status.Pending)));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View pending issues',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.redAccent,
                onPressed: () {
                  if (SessionData.adminData.locality_id == null ||
                      SessionData.adminData.locality_id.length < 2) {
                    MyWidgets.errorDialog(
                        context: context,
                        message: 'You have not assigned to any locality');
                  }
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          ViewIssues(status: Status.Rejected)));
                },
                child: SizedBox(
                  height: 80.0,
                  child: Center(
                    child: Text(
                      'View rejected issues',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getCurrentUserDashboard(var userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Your dashboard', style: TextStyle(fontSize: 16.0)),
        Divider(height: 10.0, thickness: 2.5),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Raised Issues',
                  content: userProvider.user.raised_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Solved Issues',
                  content: userProvider.user.solved_issues.toString()),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Pending Issues',
                  content: userProvider.user.pending_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                title: 'Rejected Issues',
                content: userProvider.user.rejected_issues.toString(),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _dashboardWidget({String title, String content}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  _showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }
}
