import 'package:flutter/material.dart';
import 'package:public_issue_reporter/data_models/issue.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class ViewIssueDetailed extends StatelessWidget {
  final Issue issue;

  const ViewIssueDetailed({Key key, this.issue}) : super(key: key);

  Widget buildTimeLine(Timeline timlien) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(timlien.updated_on.toString()),
              Text(timlien.updated_by.toString()),
            ],
          ),
          Text(timlien.update_description)
        ],
      ),
    );
  }

  Widget buildComment(Comment comment) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(comment.commented_on.toString()),
              Text(comment.author_id.toString()),
            ],
          ),
          Text(comment.comment)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          // mainAxisAlignment: M,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * (65 / 100),
              height: MediaQuery.of(context).size.height * (10 / 100),
              child: Image.network(
                issue.images[0].toString(),
                fit: BoxFit.fitWidth,
              ),
            ),

            ///TimeLine
            /// Comments
            Container(
              child: Text(
                issue.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            ///TimeLine
          ]
            ..addAll(issue.timeline.map((timline) => buildTimeLine(timline)))
            ..addAll(issue.comments.map((comments) => buildComment(comments)))
            ..add(MyWidgets.textField())
            ..add(RaisedButton(
              onPressed: () {},
              child: Text('Submit',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w300),),
            )),
        ),
      ),
    );
  }
}
