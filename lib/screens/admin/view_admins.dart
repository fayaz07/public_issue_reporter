import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:public_issue_reporter/data_models/admin.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/statistics_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';

class ViewAdmins extends StatefulWidget {
  @override
  _ViewAdminsState createState() => _ViewAdminsState();
}

class _ViewAdminsState extends State<ViewAdmins> {
  bool _isLoading = true;

  List<Admin> admins = [];

  @override
  void initState() {
    Admin.getAllAdminsData()
        .then((Result result) {
          print(result);
      if (result.success) {
        admins = result.data;
      }
      _hideLoader();
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Admins'),
      ),
      body: Stack(
        children: <Widget>[
          _getBody(),
          _isLoading ? Configs.loader : SizedBox(),
        ],
      ),
    );
  }

  Widget _getBody() {
    return !_isLoading && admins.length > 0
        ? ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, i) => _getAdminWidget(admins[i]))
        : SizedBox();
  }

  Widget _getAdminWidget(Admin admin) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${admin.name}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Email: ${admin.email}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Phone: ${admin.phone}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Added on: ${getDateTime(admin.created_on)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Locality ID: ${admin.locality_id}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Total issues: ${admin.total_issues}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Solved issues: ${admin.resolved_issues}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Rejected issues: ${admin.rejected_issues}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Pending issues: ${admin.pending_issues}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final formatter = new DateFormat('dd/MM/yyyy h:mm:ss a');

  String getDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }
}
