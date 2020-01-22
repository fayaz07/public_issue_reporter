import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:public_issue_reporter/login/admin_login.dart';
import 'package:public_issue_reporter/login/phone_auth/get_phone.dart';

class WhoAreYou extends StatefulWidget {
  @override
  _WhoAreYouState createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getIconButton('Admin', 'assets/admin.png', () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => AdminLogin()));
            }),
            SizedBox(height: 16.0),
            getIconButton('People', 'assets/people.png', () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => PhoneAuthGetPhone()));
            }),
          ],
        ),
      ),
    );
  }

  Widget getIconButton(String title, String asset, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 100.0,
        backgroundColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(asset, height: 150.0, width: 150.0),
              Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
