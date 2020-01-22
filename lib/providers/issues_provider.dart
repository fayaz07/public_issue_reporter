import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/data_models/issue.dart';

class IssuesProvider with ChangeNotifier {
  List<Issue> _issues = [];

  List<Issue> get issues => _issues;

  set issues(List<Issue> i) {
    _issues = i;
    notifyListeners();
  }
}
