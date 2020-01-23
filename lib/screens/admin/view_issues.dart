import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/data_models/issue.dart';

class ViewIssues extends StatefulWidget {

  Status status;

  ViewIssues(this.status);

  @override
  _ViewIssuesState createState() => _ViewIssuesState();
}

class _ViewIssuesState extends State<ViewIssues> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
