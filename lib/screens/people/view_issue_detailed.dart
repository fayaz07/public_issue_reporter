import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/data_models/locality.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class ViewIssueDetailed extends StatefulWidget {
  final Issue issue;

  const ViewIssueDetailed({Key key, this.issue}) : super(key: key);

  @override
  _ViewIssueDetailedState createState() => _ViewIssueDetailedState();
}

class _ViewIssueDetailedState extends State<ViewIssueDetailed> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue Detailed'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
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

          MyWidgets.titleContent('Status of the issue',
              '${_issue.status.toString().substring(7)}'),

          MyWidgets.titleContent(
              'Issue priority', '${_issue.priority.toString().substring(9)}'),

          MyWidgets.titleContent('Undertaking officer id',
              '${_issue.assignee_id == null ? 'Not Assigned' : _issue.assignee_id}'),

          MyWidgets.titleContent('Authority status',
              '${_issue.authority_status.toString().substring(16)}'),

          MyWidgets.titleContent(
              'Issue created on', '${Configs.getDateTime(_issue.created_on)}'),

          MyWidgets.titleContent('Issue last updated on',
              '${Configs.getDateTime(_issue.last_updated)}'),

          MyWidgets.titleContent(
              'Supported by', '${_issue.supporters.length} people'),

          MyWidgets.titleContent(
              'Opposes by', '${_issue.opposers.length} people'),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                onPressed: addSupport,
                icon: Icon(FontAwesomeIcons.thumbsUp, color: Colors.blue),
                label: Text('Support'),
              ),
              FlatButton.icon(
                onPressed: addOppose,
                icon: Icon(FontAwesomeIcons.thumbsDown, color: Colors.red),
                label: Text('Oppose'),
              ),
            ],
          )

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
                  child:
                      Center(child: Text('There are no public comments here')),
                ))
          ..addAll(_issue.comments.map((comments) => buildComment(comments)))
          ..add(SizedBox(height: 8.0))
          ..add(MyWidgets.textField(
              controller: _commentController, label: 'Add a comment'))
          ..add(
              MyWidgets.platformButton(onPressed: addComment, text: 'Comment'))
          ..add(SizedBox(height: 8.0)));
  }

  void addOppose() {
    List list = [];
    list.addAll(_issue.opposers);
    if (!list.contains(FireBase.currentUser.uid)) {
      setState(() {
        list.add(FireBase.currentUser.uid);
        _issue.opposers = list;
      });
    }

    Issue.addOpposerForIssue(_issue.id, FireBase.currentUser.uid);
  }

  void addSupport() {
    List list = [];
    list.addAll(_issue.supporters);
    if (!list.contains(FireBase.currentUser.uid)) {
      setState(() {
        list.add(FireBase.currentUser.uid);
        _issue.supporters = list;
      });
    }
    Issue.addSupportForIssue(_issue.id, FireBase.currentUser.uid);
  }

  void addComment() {
    if (_commentController.text.length < 3) {
      MyWidgets.errorDialog(context: context, message: 'Comment must be valid');
      return;
    }
    Comment comment = Comment(
        author_id: FireBase.currentUser.uid,
        comment: _commentController.text,
        commented_on: DateTime.now());

    setState(() {
      _issue.comments.add(comment);
    });
    _commentController.clear();
    Issue.addCommentToIssueWithId(_issue.id, comment).then((Result result) {
      print(result);
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
