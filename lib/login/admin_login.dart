import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/login/who_are_you.dart';
import 'package:public_issue_reporter/screens/admin/admin_home.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String email, password;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin login'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (BuildContext context) => WhoAreYou()));
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => WhoAreYou()));
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              _getBody(),
              _isLoading ? Configs.modalSheet : SizedBox(),
              _isLoading ? Configs.loader : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoader();

      FireBase.auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((AuthResult result) async {
        if (result.user != null) {
//          print("login success");
          FireBase.currentUser = await FirebaseAuth.instance.currentUser();
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => AdminHome()));
        } else {
          print('failed');
        }
      }).catchError((error) {
        print(error);
      });

      _hideLoader();
    }
  }

  var _formKey = GlobalKey<FormState>();

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.0),
            //  info text
            Align(
              alignment: Alignment.center,
              child: Text(
                'Welcome Admin',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Please enter your credentials to login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
              ),
            ),

            SizedBox(height: 32.0),

            // email and password fields
            MyWidgets.textField(
              label: 'Enter your email',
              hint: 'john@admin-issue-reporter.com',
              save: (value) => email = value,
              validator: (String value) =>
                  (value.contains("@") && value.contains("."))
                      ? null
                      : "Invalid email",
            ),
            MyWidgets.textField(
              label: 'Enter your password',
              hint: '***********',
              isObscure: true,
              save: (value) => password = value,
              validator: (String value) => Configs.validateText(
                  value: value, field: 'Password', length: 8),
            ),

            SizedBox(
              height: 32.0,
            ),
            MyWidgets.platformButton(text: 'Login', onPressed: login)
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
