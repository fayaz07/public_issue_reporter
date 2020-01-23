import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:random_string/random_string.dart';

class Issue {
  String id;

  String title;
  String description;
  String images;
  String old_references;

  List<dynamic> supporters;
  List<dynamic> opposers;

  double latitude;
  double longitude;
  String address;
  String postal_code;

  String author_id;
  String locality_id;
  String assignee_id;
  List<Comment> comments;

  DateTime created_on;
  DateTime last_updated;
  Status status;
  AuthorityStatus authority_status;
  bool authority_change_requested;
  List<Timeline> timeline;

  Priority priority;

  Map<dynamic, dynamic> additional_data;

  Issue(
      {this.id,
      this.title,
      this.description,
      this.images,
      this.old_references,
      this.latitude,
      this.longitude,
      this.address,
      this.postal_code,
      this.author_id,
      this.locality_id,
      this.assignee_id,
      this.comments,
      this.created_on,
      this.last_updated,
      this.status,
      this.authority_status,
      this.authority_change_requested,
      this.timeline,
      this.additional_data,
      this.priority,
      this.opposers,
      this.supporters});

  static List<Comment> getListOfComments(var map) {
    List<Comment> comments = [];

    for (var c in map) {
      comments.add(Comment.fromJSON(c));
    }
    return comments;
  }

  static List<Timeline> getTimelinesFromMap(var map) {
    List<Timeline> timeline = [];

    for (var c in map) {
      timeline.add(Timeline.fromJSON(c));
    }

    return timeline;
  }

  static DateTime DateTimeFromTimestamp(var timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch * 1000);
  }

  factory Issue.fromJSON(var map) {
    return Issue(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      images: map['images'],
      old_references: map['old_references'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      postal_code: map['postal_code'],
      author_id: map['author_id'],
      locality_id: map['locality_id'],
      assignee_id: map['assignee_id'],
      comments: getListOfComments(map['comments']),
      created_on: DateTimeFromTimestamp(map['created_on']),
      last_updated: DateTimeFromTimestamp(map['last_updated']),
      status: getStatusFromString(map['status'].toString()),
      authority_status:
          getAuthorityStatusFromString(map['authority_status'].toString()),
      authority_change_requested: map['authority_change_requested'],
      timeline: getTimelinesFromMap(map['timeline']),
      additional_data: map['additional_data'],
      priority: getPriorityFromString(map['priority'].toString()),
      supporters: map['supporters'],
      opposers: map['opposers'],
    );
  }

  static Priority getPriorityFromString(String pri) {
    switch (pri) {
      case "High":
        return Priority.High;
      case "Low":
        return Priority.Low;
      case "Medium":
        return Priority.Medium;
    }
    return Priority.High;
  }

  static AuthorityStatus getAuthorityStatusFromString(String pri) {
    switch (pri) {
      case "Sarpanch":
        return AuthorityStatus.Sarpanch;
      case "ViceSarpanch":
        return AuthorityStatus.ViceSarpanch;
      case "WardMember":
        return AuthorityStatus.WardMember;
    }
    return AuthorityStatus.WardMember;
  }

  static Status getStatusFromString(String s) {
    switch (s) {
      case "Accepted":
        return Status.Accepted;
      case "Closed":
        return Status.Closed;
      case "Pending":
        return Status.Pending;
      case "Rejected":
        return Status.Rejected;
    }
    return Status.Pending;
  }

  static Map<String, dynamic> toJSON(Issue issue) {
    return {
      'id': issue.id,
      'title': issue.title,
      'description': issue.description,
      'images': issue.images,
      'old_references': issue.old_references,
      'latitude': issue.latitude,
      'longitude': issue.longitude,
      'address': issue.address,
      'postal_code': issue.postal_code,
      'author_id': issue.author_id,
      'locality_id': issue.locality_id,
      'assignee_id': issue.assignee_id,
      'comments': issue.comments,
      'created_on': issue.created_on,
      'last_updated': issue.last_updated,
      'status': issue.status.toString().substring(7),
      'authority_status': issue.authority_status.toString().substring(16),
      'authority_change_requested': issue.authority_change_requested,
      'timeline': issue.timeline,
      'additional_data': issue.additional_data,
      'priority': issue.priority.toString().substring(9),
      'supporters': issue.supporters,
      'opposers': issue.opposers,
    };
  }

  /// Database operations
  ///

  static Future<Result> createIssue(Issue issue) async {
    Result result = Result();

    var id = randomAlphaNumeric(7);

    issue.id = id;

    await FireBase.issuesCollection
        .document(id)
        .setData(toJSON(issue))
        .whenComplete(() {
      result = Result(
          success: true, hasData: false, message: 'Successfully posted issue');
    }).catchError((error) {
      print(error);
      result = Result(
          success: false,
          hasData: false,
          message: 'Failed to post issue ${error.toString()}');
    });
    return result;
  }

  static Future<Result> fetchIssuesWithLimitForCurrentUser() async {
    Result result = Result();
    await FireBase.issuesCollection
        .where('author_id', isEqualTo: FireBase.currentUser.uid)
        .getDocuments(source: Source.serverAndCache)
        .then((QuerySnapshot snapshot) {
      List<Issue> issues = [];
      for (var c in snapshot.documents) {
        issues.add(Issue.fromJSON(c.data));
      }

      result = Result(
          success: true,
          hasData: true,
          message: 'Fetched issues',
          data: issues);
    }).catchError((error) {
      result =
          Result(success: false, hasData: false, message: error.toString());
    });
    return result;
  }

  static Future<Result> fetchIssuesWithStatusAndLocalityId(){

  }

}

enum Priority { Low, Medium, High }

enum AuthorityStatus { WardMember, ViceSarpanch, Sarpanch }

enum Status { Pending, Accepted, Rejected, Closed }

class Comment {
  String author_id;
  String comment;
  DateTime commented_on;

  Comment({this.author_id, this.comment, this.commented_on});

  factory Comment.fromJSON(var map) {
    Timestamp timestamp = map['commented_on'];

    var dateTime = DateTime.fromMicrosecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch * 1000);

    return Comment(
      author_id: map['author_id'],
      comment: map['comment'],
      commented_on: dateTime,
    );
  }

  static Map<String, dynamic> toJSON(Comment comment) {
    return {
      'author_id': comment.author_id,
      'comment': comment.comment,
      'commented_on': comment.commented_on,
    };
  }
}

class Timeline {
  DateTime updated_on;
  String updated_by;
  String update_description;

  Timeline({this.updated_on, this.updated_by, this.update_description});

  factory Timeline.fromJSON(var map) {
    return Timeline(
      update_description: map['update_description'],
      updated_by: map['updated_by'],
      updated_on: Issue.DateTimeFromTimestamp(map['updated_on']),
    );
  }

  static Map<String, dynamic> toJSON(Timeline timeline) {
    return {
      'update_description': timeline.update_description,
      'updated_by': timeline.updated_by,
      'updated_on': timeline.updated_on,
    };
  }
}
