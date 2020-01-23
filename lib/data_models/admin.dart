import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_issue_reporter/backend/initialize.dart';
import 'package:public_issue_reporter/data_models/result.dart';

class Admin {
  String uid;
  String name;
  String locality_id;
  DateTime created_on;
  String email;
  String phone;
  AdminType admin_type;
  int total_issues;
  int resolved_issues;
  int pending_issues;
  int rejected_issues;

  Admin(
      {this.uid,
      this.name,
      this.locality_id = '',
      this.created_on,
      this.email,
      this.admin_type,
      this.total_issues = 0,
      this.resolved_issues = 0,
      this.pending_issues = 0,
      this.rejected_issues = 0,
      this.phone});

  /// Helper methods
  /// For conversions [fromJSON], [toJSON], [adminTypeFromString], [adminTypeToString]
  ///

  factory Admin.fromJSON(var map) {
    Timestamp timestamp = map['created_on'];

    var dateTime = DateTime.fromMicrosecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch * 1000);
    return Admin(
      uid: map['uid'],
      name: map['name'],
      locality_id: map['locality_id'],
      created_on: dateTime,
      email: map['email'],
      admin_type: adminTypeFromString(map['admin_type']),
      total_issues: map['total_issues'],
      resolved_issues: map['resolved_issues'],
      pending_issues: map['pending_issues'],
      rejected_issues: map['rejected_issues'],
      phone: map['phone'],
    );
  }

  static Map<String, dynamic> toJSON(Admin admin) {
    return {
      'uid': admin.uid,
      'name': admin.name,
      'locality_id': admin.locality_id,
      'created_on': admin.created_on,
      'email': admin.email,
      'admin_type': adminTypeToString(admin.admin_type),
      'total_issues': admin.total_issues,
      'resolved_issues': admin.resolved_issues,
      'pending_issues': admin.pending_issues,
      'rejected_issues': admin.rejected_issues,
      'phone': admin.phone,
    };
  }

  static String adminTypeToString(AdminType adminType) {
    switch (adminType) {
      case AdminType.Main:
        return "Main";
        break;
      case AdminType.Locality:
        return "Locality";
        break;
    }
    return "Locality";
  }

  static AdminType adminTypeFromString(String adminType) {
    switch (adminType) {
      case "Main":
        return AdminType.Main;
        break;
      case "Locality":
        return AdminType.Locality;
        break;
    }
    return AdminType.Locality;
  }

  /// Database operations
  ///

  static Future<Result> getAdminData() async {
    Result result = Result();
    await FireBase.adminCollection
        .document(FireBase.currentUser.uid)
        .get(source: Source.serverAndCache)
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        result = Result(
            success: true,
            message: 'Fetched data successfully',
            hasData: true,
            data: Admin.fromJSON(snapshot.data));
      } else {
        result = Result(
          success: false,
          message: 'Data doesn\'t exists',
          hasData: false,
        );
      }
    }).catchError((error) {
      result = Result(
        success: false,
        message: error.message,
        hasData: false,
      );
    });
    return result;
  }

  static Future<Result> getAllAdminsData() async {
    Result result = Result();
    await FireBase.adminCollection
        .getDocuments(source: Source.serverAndCache)
        .then((QuerySnapshot snapshot) {
      List<Admin> admins = [];

      for (var c in snapshot.documents) {
        admins.add(Admin.fromJSON(c.data));
      }

      result = Result(
          success: true,
          message: 'Fetched admins data successfully',
          hasData: true,
          data: admins);
    }).catchError((error) {
      result = Result(
        success: false,
        message: error.toString(),
        hasData: false,
      );
    });
    return result;
  }

  static Future<Result> getAdminDataById(String uid) async {
    Result result = Result();
    await FireBase.adminCollection
        .document(uid)
        .get(source: Source.serverAndCache)
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        result = Result(
            success: true,
            message: 'Fetched data successfully',
            hasData: true,
            data: Admin.fromJSON(snapshot.data));
      } else {
        result = Result(
          success: false,
          message: 'Data doesn\'t exists',
          hasData: false,
        );
      }
    }).catchError((error) {
      result = Result(
        success: false,
        message: error.message,
        hasData: false,
      );
    });
    return result;
  }

  static Future<Result> setAdminData(Admin admin) async {
    Result result = Result();
    await FireBase.adminCollection
        .document(FireBase.currentUser.uid)
        .setData(toJSON(admin))
        .whenComplete(() {
      result = Result(
          success: true,
          message: 'Updated data successfully',
          hasData: true,
          data: admin);
    }).catchError((error) {
      result = Result(
        success: false,
        message: error.message,
        hasData: false,
      );
    });
    return result;
  }

  static Future<Result> setAdminLocality(
      {String admin_id, String locality_id}) async {
    Result result = Result();
    await FireBase.adminCollection
        .document(admin_id)
        .setData({'locality_id': locality_id}, merge: true).whenComplete(() {
      result = Result(
          success: true, message: 'Updated data successfully', hasData: false);
    }).catchError((error) {
      print(error);
      result = Result(
        success: false,
        message: error.message,
        hasData: false,
      );
    });
    return result;
  }

  static Future<Result> getUnAllocatedAdmins() async {
    Result result = Result();
    await FireBase.adminCollection
        .where('locality_id', isEqualTo: '')
        .getDocuments(source: Source.server)
        .then((QuerySnapshot snapshot) {
      List<Admin> admins = [];

      for (var c in snapshot.documents) {
        admins.add(Admin.fromJSON(c.data));
      }
      result = Result(
          success: true,
          message: 'Fetched unallocated admins ',
          hasData: true,
          data: admins);
    }).catchError((error) {
      result = Result(
        success: false,
        message: error.toString(),
        hasData: false,
      );
    });
    return result;
  }
}

enum AdminType { Main, Locality }
