import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/admin.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/admin/admin_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/session_data.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(
        children: <Widget>[
          _getBody(),
          _isLoading ? Configs.modalSheet : SizedBox(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  var _formKey = GlobalKey<FormState>();
  Admin admin = Admin();

  saveData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      admin.email = FireBase.currentUser.email;
      admin.uid = FireBase.currentUser.uid;
      _showLoader();

      admin.created_on = FireBase.currentUser.metadata.creationTime;

      if (admin.email.contains("issue-reporter.com"))
        admin.admin_type = AdminType.Main;
      else
        admin.admin_type = AdminType.Locality;

      await Admin.setAdminData(admin).then((Result result) {
        print(result);
        if (result.success) {
          Provider.of<AdminProvider>(context, listen: false).admin =
              result.data;
          SessionData.adminData = result.data;
          Navigator.of(context).pop();
        }
      }).catchError((error) {
        print(error);
      });
      _hideLoader();
    }
  }

  Widget _getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16.0),
                MyWidgets.textField(
                  label: 'Name',
                  hint: 'John Doe',
                  save: (value) => admin.name = value,
                  validator: (value) => Configs.validateText(
                      field: 'Name', value: value, length: 3),
                ),
                MyWidgets.textField(
                  label: 'Email',
                  initialValue: FireBase.currentUser.email,
                  enabled: false,
                ),
                MyWidgets.textField(
                  label: 'Phone',
                  hint: '+91123456789',
                  save: (value) => admin.phone = value,
                  validator: (value) => Configs.validateText(
                      field: 'Phone', value: value, length: 10),
                ),
                SizedBox(height: 32.0),
                MyWidgets.platformButton(
                  text: 'Save',
                  onPressed: saveData,
                )
              ],
            ),
          ),
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
