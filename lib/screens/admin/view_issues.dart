import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/admin.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/issues_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/session_data.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

import 'view_issue_detailed.dart';

// ignore: must_be_immutable
class ViewIssues extends StatefulWidget {
  Status status;

  ViewIssues({this.status});

  @override
  _ViewIssuesState createState() => _ViewIssuesState();
}

class _ViewIssuesState extends State<ViewIssues> {
  bool _isLoading = true;

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

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  fetchIssues() async {
    try {
      Result result;
      //  Fetch data
      if (SessionData.adminData.admin_type == AdminType.Main)
        result = await Issue.fetchAllIssues();
      else
        result = await Issue.fetchIssuesWithStatusAndLocalityId(
            locality_id: SessionData.adminData.locality_id,
            status: widget.status);
      _hideLoader();

      //  Handle result
      if (result.success)
        Provider.of<IssuesProvider>(context, listen: false).issues =
            result.data;
      else
        MyWidgets.errorDialog(context: context, message: result.message);
    } catch (error) {
      MyWidgets.errorDialog(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = Provider.of<IssuesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(SessionData.adminData.admin_type == AdminType.Main
            ? 'All Issues'
            : 'Issues in your locality'),
      ),
      body: Stack(
        children: <Widget>[
          _getBody(issuesProvider),
          _isLoading ? Configs.modalSheet : SizedBox(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  Widget _getBody(IssuesProvider issuesProvider) {
    return issuesProvider.issues.length > 0
        ? ListView.builder(
            itemCount: issuesProvider.issues.length,
            itemBuilder: (context, i) => InkWell(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => ViewIssueDetailedAdmin(
                            issue: issuesProvider.issues[i],
                          )));
                },
                child: MyWidgets.issueWidget(issuesProvider.issues[i])))
        : _isLoading ? SizedBox() : Center(child: Text('No issues here'));
  }
}
