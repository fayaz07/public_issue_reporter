import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/data_models/locality.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/issues_provider.dart';
import 'package:public_issue_reporter/screens/admin/ViewMap.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/custom_drop_down_button.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class ViewIssueDetailedAdmin extends StatefulWidget {
  final Issue issue;

  const ViewIssueDetailedAdmin({Key key, this.issue}) : super(key: key);

  @override
  _ViewIssueDetailedAdminState createState() => _ViewIssueDetailedAdminState();
}

class _ViewIssueDetailedAdminState extends State<ViewIssueDetailedAdmin> {
  Issue _issue;

//  Locality locality;

  StreamController<Locality> _localityController = StreamController();
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _localityController.close();
    //_commentController.dispose();
  }

  @override
  void initState() {
    _issue = widget.issue;

    //  Fetching Locality details from locality id
    Locality.getLocalityById(_issue.locality_id).then((Result result) {
      //locality = result.data;
      //print(result);
      _localityController.add(result.data);
    });

    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue Detailed'),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: _getBody(),
              ),
            ),
          ),
          _isLoading ? Configs.modalSheet : SizedBox(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  Widget _getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 32.0),
        CachedNetworkImage(
          imageUrl: _issue.images,
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          placeholder: (context, data) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),

        SizedBox(height: 8.0),
        MyWidgets.titleContent('Issue', _issue.title),

        MyWidgets.titleContent('About the issue', _issue.description),

        MyWidgets.titleContent(
            'Old references',
            _issue.old_references.length > 2
                ? _issue.old_references
                : 'Not applicable'),

        MyWidgets.titleContent('Address', '${_issue.address}'),

        MyWidgets.titleContent('Postal Code', '${_issue.postal_code}'),

        MyWidgets.titleContent(
            'Status of the issue', '${_issue.status.toString().substring(7)}'),

        _issue.status == Status.Solved
            ? SizedBox()
            : MyWidgets.platformButton(
                text: 'Update Status',
                onPressed: selectAndUpdateIssueStatus,
              ),

        MyWidgets.titleContent(
            'Issue priority', '${_issue.priority.toString().substring(9)}'),

        MyWidgets.titleContent('Undertaking officer id',
            '${_issue.assignee_id == null ? 'Not Assigned' : _issue.assignee_id}'),

        //  Button to assign the issue to self, if no one assigned
        _issue.assignee_id == null
            ? MyWidgets.platformButton(
                text: 'Assign yourself',
                onPressed: assignIssueToSelf,
              )
            : SizedBox(),

        MyWidgets.titleContent('Authority status',
            '${_issue.authority_status.toString().substring(16)}'),

        _issue.status == Status.Solved
            ? SizedBox()
            : MyWidgets.platformButton(
                text: 'Update Authority Status',
                onPressed: selectAndUpdateAuthorityStatus,
              ),

        MyWidgets.titleContent(
            'Issue created on', '${Configs.getDateTime(_issue.created_on)}'),

        MyWidgets.titleContent('Issue last updated on',
            '${Configs.getDateTime(_issue.last_updated)}'),

        MyWidgets.titleContent(
            'Supported by', '${_issue.supporters.length} people'),

        MyWidgets.titleContent(
            'Opposes by', '${_issue.opposers.length} people'),

        ///TimeLine
      ]
        ..add(StreamBuilder<Locality>(
            stream: _localityController.stream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? MyWidgets.titleContent('Locality', snapshot.data.name)
                  : SizedBox();
            }))
        ..add(SizedBox(height: 8.0))
        ..add(Text('Timeline',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)))
        ..add(_issue.timeline.length > 0
            ? SizedBox(height: 8.0)
            : SizedBox(
                height: 32.0,
                child: Center(
                    child: Text(
                        'Authorities will respond shortly, please comeback later')),
              ))
        ..addAll(_issue.timeline.map((timeline) => buildTimeLine(timeline)))
        ..add(SizedBox(height: 8.0))
        ..add(Text('Public Comments',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)))
        ..add(_issue.comments.length > 0
            ? SizedBox(height: 8.0)
            : SizedBox(
                height: 32.0,
                child: Center(child: Text('There are no public comments here')),
              ))
        ..addAll(_issue.comments.map((comments) => buildComment(comments)))
        ..add(Center(
          child: FlatButton.icon(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        ViewMap(LatLng(_issue.latitude, _issue.longitude))));
              },
              icon: Icon(FontAwesomeIcons.map),
              label: Text('View in Map')),
        ))
        ..add(SizedBox(height: 8.0))
        ..add(_issue.status == Status.Solved
            ? SizedBox()
            : MyWidgets.platformButton(
                text: 'Mark Issue as Solved',
                onPressed: () async {
                  _showLoader();
                  await Issue.changeIssueStatus(_issue.id, Status.Solved);
                  _hideLoader();
                },
              ))
        ..add(SizedBox(height: 16.0)),
    );
  }

  Future<void> assignIssueToSelf() async {
    _showLoader();

    if (_issue.assignee_id == null || _issue.assignee_id.length < 2) {
      _issue.assignee_id = FireBase.currentUser.uid;
      Provider.of<IssuesProvider>(context, listen: false).updateAnIssue(_issue);
      setState(() {});
      await Issue.assignIssueSelf(_issue.id, FireBase.currentUser.uid);
    } else {
      MyWidgets.errorDialog(
          context: context, message: "Issue is already assigned to an admin");
    }
    _hideLoader();
  }

  void selectAndUpdateIssueStatus() {
    _showLoader();
    MyWidgets.dialog(
      context: context,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Update Issue Status',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700)),
            SizedBox(height: 8.0),
            Text('Please select the status from the dropdown list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                )),
            SizedBox(height: 8.0),
            DropDownButton(
              title: 'Status',
              items: [
                Status.Pending.toString(),
                Status.Rejected.toString(),
                Status.Solved.toString(),
              ],
              onSelected: (status) {
                Status.values.forEach((Status s) {
                  if (s.toString().contains(status)) {
                    _issue.status = s;
                    return;
                  }
                });
              },
            ),
            FlatButton(
                onPressed: () {
                  updateIssueStatus();
                  Navigator.of(context).pop();
                },
                child: Text('Ok'))
          ],
        ),
      ),
    );
    _hideLoader();
  }

  void selectAndUpdateAuthorityStatus() {
    MyWidgets.dialog(
      context: context,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Update Authority Status',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700)),
            SizedBox(height: 8.0),
            Text('Please select the status from the dropdown list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                )),
            SizedBox(height: 8.0),
            DropDownButton(
              title: 'Authority Status',
              items: [
                AuthorityStatus.WardMember.toString(),
                AuthorityStatus.ViceSarpanch.toString(),
                AuthorityStatus.Sarpanch.toString(),
              ],
              onSelected: (status) {
                AuthorityStatus.values.forEach((AuthorityStatus s) {
                  if (s.toString().contains(status)) {
                    _issue.authority_status = s;
                    return;
                  }
                });
              },
            ),
            FlatButton(
                onPressed: () {
                  updateAuthorityStatus();
                  Navigator.of(context).pop();
                },
                child: Text('Ok'))
          ],
        ),
      ),
    );
  }

  Future<void> updateAuthorityStatus() async {
    _showLoader();
    await Issue.changeAuthorityStatus(_issue.id, _issue.authority_status);
    _hideLoader();
  }

  Future<void> updateIssueStatus() async {
    _showLoader();
    await Issue.changeIssueStatus(_issue.id, _issue.status);
    _hideLoader();
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

  Widget buildTimeLine(Timeline timeline) {
    return Material(
      type: MaterialType.card,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(timeline.update_description,
                        style: TextStyle(fontSize: 16.0, color: Colors.white))),
              ],
            ),
            SizedBox(height: 4.0),
            Text(Configs.getDateTime(timeline.updated_on),
                style: TextStyle(fontSize: 10.0, color: Colors.white)),
            SizedBox(height: 2.0),
            Text(timeline.updated_by,
                style: TextStyle(fontSize: 10.0, color: Colors.white)),
            SizedBox(height: 2.0),
            //Text(comment.author_id.toString(), style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
    );
  }

  Widget buildComment(Comment comment) {
    return Material(
      type: MaterialType.card,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(comment.comment,
                        style: TextStyle(fontSize: 16.0, color: Colors.white))),
              ],
            ),
            SizedBox(height: 4.0),
            Text(Configs.getDateTime(comment.commented_on),
                style: TextStyle(fontSize: 10.0, color: Colors.white)),
            SizedBox(height: 2.0),
            //Text(comment.author_id.toString(), style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
    );
  }
}
