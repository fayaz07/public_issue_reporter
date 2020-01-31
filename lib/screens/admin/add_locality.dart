import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/admin.dart';
import 'package:public_issue_reporter/data_models/locality.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/custom_drop_down_button.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class AddLocality extends StatefulWidget {
  @override
  _AddLocalityState createState() => _AddLocalityState();
}

class _AddLocalityState extends State<AddLocality> {
  bool _isLoading = true;

  List<Admin> admins = [];

  @override
  void initState() {
    Admin.getUnAllocatedAdmins().then((Result result) {
      if (result.success) {
        admins = result.data;
        if (admins.length == 0) {
          //  TODO: show dialog
          print('no admins');
        }
      }
      _hideLoader();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Locality'),
      ),
      body: Stack(
        children: <Widget>[
          _isLoading ? SizedBox() : _getBody(),
          _isLoading ? Configs.modalSheet : SizedBox(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  var _formKey = GlobalKey<FormState>();

  saveData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoader();
      locality.added_by = FireBase.currentUser.uid;
      await Locality.addLocality(locality).whenComplete(() {
        print('Success');
        Navigator.of(context).pop();
      }).catchError((error) {});
      _hideLoader();
    }
  }

  Locality locality = Locality();

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
                  label: 'Name of locality',
                  hint: 'Ex: Narsapur',
                  save: (value) => locality.name = value,
                  validator: (value) =>
                      Configs.validateText(
                          field: 'Name', value: value, length: 3),
                ),
                admins.length > 0
                    ? DropDownButton(
                    title: 'Select admin to be assigned',
                    items: List.generate(
                        admins.length,
                            (int i) =>
                        admins[i].name + ' (' + admins[i].email + ')'),
                    onSelected: (value) {
//                    locality.admin_id =
                      admins.forEach((Admin a) {
                        if (value.toString().contains(a.email)) {
                          locality.admin_id = a.uid;
                          print(locality.admin_id);
                          return;
                        }
                      });
                    })
                    : SizedBox(
                  child: Text('No admins'),
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
