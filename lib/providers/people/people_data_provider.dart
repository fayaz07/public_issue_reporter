import 'package:flutter/material.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/data_models/people.dart';
import 'package:flutter/foundation.dart';

class PeopleProvider extends ChangeNotifier {
  People _user = People();

  People get user => _user;

  set user(People value) {
    _user = value;
    notifyListeners();
  }

  updateUser({@required People modifiedUser}) {
    _user.name = modifiedUser.name ?? user.name;
    _user.phone = modifiedUser.phone ?? user.phone;
    _user.additional_data =
        modifiedUser.additional_data ?? user.additional_data;
    _user.uid = modifiedUser.uid ?? user.uid;
    notifyListeners();
  }

}
