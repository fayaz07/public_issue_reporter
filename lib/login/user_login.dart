import 'package:flutter/material.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  double _fixedPadding = 8.0;
  bool _isOtpSent = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
              Padding(
                padding: EdgeInsets.all(_fixedPadding),
                child:
                Image.asset('assets/logo.png', height: 150.0, width: 150.0),
              ),

              // AppName:
              Text("Public Issue Reporter",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700)),

              //  Subtitle for Enter your phone
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
                child: Text(
                  'Enter your phone',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              //  PhoneNumber TextFormFields
              Padding(
                padding: EdgeInsets.only(
                    left: _fixedPadding,
                    right: _fixedPadding,
                    bottom: _fixedPadding),
                child:Card(
                  child: TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    key: Key('EnterPhone-TextFormField'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorMaxLines: 1,
                      prefix: Text("  +91  "),
                    ),
                  ),
                ),
              ),

              /*
           *  Some informative text
           */
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: _fixedPadding),
                  Icon(Icons.info, color: Colors.white, size: 20.0),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'We will send ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                          TextSpan(
                              text: 'One Time Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: ' to this mobile number',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ])),
                  ),
                  SizedBox(width: _fixedPadding),
                ],
              ),

              /*
           *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
           *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
           *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
           */
              SizedBox(height: _fixedPadding * 1.5),
              RaisedButton(
                elevation: 15.0,
                onPressed: () {
                  startPhoneAuth();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'SEND OTP',
                    style: TextStyle(
                        color: Colors.green, fontSize: 18.0),
                  ),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ],
          )
        ],
      ),
    );
  }

  startPhoneAuth() {

  }
}
