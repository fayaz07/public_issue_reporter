import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/data_models/people.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  People people = People();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16.00),
                MyWidgets.textField(
                  label: 'Name',
                  hint: 'John Doe',
                  save: (value) => people.name = value,
                  validator: (value) => Configs.validateText(
                      field: 'Name', value: value, length: 3),
                ),
                MyWidgets.textField(
                  label: 'Phone',
                  enabled: false,
                  initialValue: FireBase.currentUser.phoneNumber,
                ),
                MyWidgets.textField(
                  maxLines: 3,
                  label: 'Address',
                  hint: 'Please provide your full resident address',
                  save: (value) => people.address = value,
                  validator: (value) => Configs.validateText(
                      field: 'Address', value: value, length: 10),
                ),
                SizedBox(height: 32.00),
                MyWidgets.platformButton(
                    text: 'Submit',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        people.uid = FireBase.currentUser.uid;
                        people.phone = FireBase.currentUser.phoneNumber;

                        People.updateUserData(people: people)
                            .then((Result result) {
                          if (result.success)
                            Provider.of<PeopleProvider>(context, listen: false).user = people;
                          Navigator.of(context).pop();
                        });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
