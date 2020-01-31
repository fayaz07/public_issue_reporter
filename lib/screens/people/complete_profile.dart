import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/locality.dart';
import 'package:public_issue_reporter/data_models/people.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/admin/localities_provider.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/custom_drop_down_button.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  People people = People();

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Locality.getLocalities().then((Result result) {
      if (result.success)
        Provider.of<LocalitiesProvider>(context, listen: false).localities =
            result.data;
    }).catchError((error) {
      print(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localitiesProvider = Provider.of<LocalitiesProvider>(context);

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
                localitiesProvider.localities.length > 0
                    ? DropDownButton(
                        items: List.generate(
                            localitiesProvider.localities.length, (int i) {
                          return localitiesProvider.localities[i].name
                              .toString();
                        }),
                        title: 'Select your locality',
                        onSelected: (value) {
                          localitiesProvider.localities.forEach((Locality l) {
                            if (l.name.contains(value)) {
                              people.locality_id = l.locality_id;
                              return;
                            }
                          });
                        },
                      )
                    : SizedBox(height: 50.0, child: Configs.loader),
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
                            Provider.of<PeopleProvider>(context, listen: false)
                                .user = people;
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
