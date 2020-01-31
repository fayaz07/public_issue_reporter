import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/firebase/initialize.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:random_string/random_string.dart';

import 'admin.dart';

class Locality {
  String locality_id;
  String name;
  String added_by;
  DateTime added_on;
  String admin_id;

  var additional_data;

  Locality(
      {this.locality_id,
      this.name,
      this.added_by,
      this.added_on,
      this.admin_id});

  factory Locality.fromJSON(var map) {
    return Locality(
      locality_id: map['locality_id'],
      name: map['name'],
      added_by: map['added_by'],
      added_on: DateTime.fromMicrosecondsSinceEpoch(
          map['added_on'].millisecondsSinceEpoch * 1000),
      admin_id: map['admin_id'],
    );
  }

  static Map<String, dynamic> toJSON(Locality locality) {
    return {
      'locality_id': locality.locality_id,
      'name': locality.name,
      'added_by': locality.added_by,
      'added_on': locality.added_on,
      'admin_id': locality.admin_id,
    };
  }

  static Future<Result> addLocality(Locality locality) async {
    Result result = Result();
    var id = randomAlphaNumeric(7);
    locality.locality_id = id;
    locality.added_on = DateTime.now();
    await FireBase.localityCollection
        .document(id)
        .setData(toJSON(locality))
        .whenComplete(() async {
      ///
      await Admin.setAdminLocality(
          admin_id: locality.admin_id, locality_id: locality.locality_id);

      result = Result(
          success: true,
          hasData: false,
          message: 'Added locality successfully');
    }).catchError((error) {
      print(error);
      result = Result(
          success: false,
          hasData: false,
          message: 'Adding locality failed ${error.message}');
    });
    return result;
  }

  static Future<Result> getLocalityById(String id) async {
    Result result = Result();

    await FireBase.localityCollection
        .document(id)
        .get(source: Source.serverAndCache)
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists)
        result = Result(
            success: true,
            hasData: true,
            data: Locality.fromJSON(snapshot.data),
            message: 'Fetched locality successfully');
      else
        result = Result(
            success: false, hasData: false, message: 'fetch locality failed');
    }).catchError((error) {
      print(error);
      result = Result(
          success: false,
          hasData: false,
          message: 'Adding locality failed ${error.message}');
    });
    return result;
  }

  static Future<Result> getLocalities() async {
    Result result = Result();

    await FireBase.localityCollection
        .getDocuments(source: Source.serverAndCache)
        .then((QuerySnapshot snapshot) async {
      List<Locality> localities = [];
      for (var c in snapshot.documents) {
        Locality l = Locality.fromJSON(c.data);
        await Admin.getAdminDataById(l.admin_id).then((Result result) {
          l.additional_data = result.data;
        });
        localities.add(l);
      }

      result = Result(
          success: true,
          hasData: true,
          data: localities,
          message: 'Fetched localities');
    }).catchError((error) {
      print(error);
      result = Result(
          success: false,
          hasData: false,
          message: 'Adding locality failed ${error.message}');
    });
    return result;
  }

  static Future<Result> deleteLocality(String id) async {
    Result result = Result();

    await FireBase.localityCollection.document(id).delete().then((v) {
      result = Result(success: true, message: 'Deleted locality successfully');
    }).catchError((error) {
      print(error);
      result = Result(
          success: false,
          hasData: false,
          message: 'Deleting locality failed ${error.message}');
    });
    return result;
  }
}
