import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';

class People with ChangeNotifier {
  String uid;
  String name;
  String phone;

  // ignore: non_constant_identifier_names
  int raised_issues;

  // ignore: non_constant_identifier_names
  int solved_issues;

  // ignore: non_constant_identifier_names
  int pending_issues;

  // ignore: non_constant_identifier_names
  int rejected_issues;

  String locality_id;
  String address;

  Map<dynamic, dynamic> additional_data;

  People(
      {this.uid,
      this.name,
      this.phone,
      // ignore: non_constant_identifier_names
      this.additional_data,
      // ignore: non_constant_identifier_names
      this.raised_issues = 0,
      // ignore: non_constant_identifier_names
      this.solved_issues = 0,
      // ignore: non_constant_identifier_names
      this.rejected_issues = 0,
      // ignore: non_constant_identifier_names
      this.pending_issues,
      this.locality_id,
      this.address}) {
    this.pending_issues =
        this.raised_issues - this.solved_issues - this.rejected_issues;
  }

  factory People.fromJSON(var map) {
    return People(
      name: map['name'],
      additional_data: map['additional_data'],
      uid: map['uid'],
      phone: map['phone'],
      address: map['address'],
      locality_id: map['locality_id'],
      pending_issues: map['pending_issues'],
      raised_issues: map['raised_issues'],
      rejected_issues: map['rejected_issues'],
      solved_issues: map['solved_issues'],
    );
  }

  static Map<String, dynamic> toJSON(People people) {
    return {
      "name": people.name,
      "additional_data": people.additional_data,
      "uid": people.uid,
      "phone": people.phone,
      "address": people.address,
      "locality_id": people.locality_id,
      "pending_issues": people.pending_issues,
      "raised_issues": people.raised_issues,
      "rejected_issues": people.rejected_issues,
      "solved_issues": people.solved_issues,
    };
  }

  static Future<Result> updateUserData({People people}) async {
    Result result = Result();
    await FireBase.peopleCollection
        .document(FireBase.currentUser.uid)
        .setData(People.toJSON(people))
        .whenComplete(() {
      print('user data updated');
      result = Result(
          success: true,
          message: 'Updated people data successfully',
          data: people,
          hasData: true);
    }).catchError((error) {
      print(error);
    });
    return result;
  }

  static Future<Result> fetchUserData() async {
    print('fetching user data');
    Result result = Result();
    await FireBase.peopleCollection
        .document(FireBase.currentUser.uid)
        .get(source: Source.serverAndCache)
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        People people = People.fromJSON(snapshot.data);
        result = Result(
            success: true,
            data: people,
            hasData: true,
            message: 'Fetched people data successfully');
      } else {
        result = Result(
            success: true,
            message: 'People data doesn\'t exist',
            hasData: false);
      }
    }).catchError((error) {
      print(error);
    });

    return result;
  }
}
