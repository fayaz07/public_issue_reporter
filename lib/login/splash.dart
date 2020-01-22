import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/login/who_are_you.dart';
import 'package:public_issue_reporter/screens/admin/admin_home.dart';
import 'package:public_issue_reporter/screens/people/people_home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUser() {
    FireBase.initialize().then((logged_in_data) {
      if (logged_in_data['logged_in'] && logged_in_data['user_type']==1)
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => PeopleHome()));
      else if (logged_in_data['logged_in'] && logged_in_data['user_type']==2)
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => AdminHome()));
      else
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (BuildContext context) => WhoAreYou()));
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      checkUser();
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png', height: 200.0, width: 200.0),
      ),
    );
  }
}
