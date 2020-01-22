import 'package:flutter/foundation.dart';
import 'package:public_issue_reporter/data_models/admin.dart';

class AdminProvider with ChangeNotifier{
  Admin _admin  = Admin();

  Admin get admin => _admin;

  set admin(Admin adminData){
    _admin = adminData;
    notifyListeners();
  }


}