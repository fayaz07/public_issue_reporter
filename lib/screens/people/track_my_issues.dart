import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/issues_provider.dart';
import 'package:public_issue_reporter/screens/people/view_issue_detailed.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class TrackIssues extends StatefulWidget {
  @override
  _TrackIssuesState createState() => _TrackIssuesState();
}

class _TrackIssuesState extends State<TrackIssues> {
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
    Issue.fetchIssuesWithLimitForCurrentUser().then((Result result) {
      _hideLoader();
      print(result);
      if (result.success)
        Provider.of<IssuesProvider>(context, listen: false).issues =
            result.data;
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = Provider.of<IssuesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Track your issues'),
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
                      builder: (BuildContext context) => ViewIssueDetailed(
                            issue: issuesProvider.issues[i],
                          )));
                },
                child: MyWidgets.issueWidget(issuesProvider.issues[i])))
        : _isLoading
            ? SizedBox()
            : Center(child: Text('You didn\'t post any issues'));
  }
}
