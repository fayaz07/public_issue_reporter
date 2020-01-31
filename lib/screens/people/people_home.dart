import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/people.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/screens/people/complete_profile.dart';
import 'package:public_issue_reporter/providers/statistics_provider.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';
import 'package:public_issue_reporter/screens/people/raise_issue.dart';
import 'package:public_issue_reporter/screens/people/track_my_issues.dart';
import 'package:public_issue_reporter/screens/people/user_profile.dart';
import 'package:public_issue_reporter/utils/configs.dart';

class PeopleHome extends StatefulWidget {
  @override
  _PeopleHomeState createState() => _PeopleHomeState();
}

class _PeopleHomeState extends State<PeopleHome> {
  int _currentScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    People.fetchUserData().then((Result result) {
      print(result.message);
      if (result.success && result.hasData)
        Provider.of<PeopleProvider>(context, listen: false).user = result.data;
      else
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => CompleteProfile()));
      _hideLoader();
    });
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final peopleDataProvider = Provider.of<PeopleProvider>(context);
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    print("Name ${peopleDataProvider.user.name}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Home'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            peopleDataProvider.user.uid != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: [
                      buildHomeScreen(peopleDataProvider, statisticsProvider),
                     // getNotificationScreen(),
                      getProfile(),
                    ].elementAt(_currentScreenIndex),
                  )
                : SizedBox(),
            _isLoading ? Configs.modalSheet : SizedBox(),
            _isLoading ? Configs.loader : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavbar(),
    );
  }

  var _formKey = GlobalKey<FormState>();

  Widget buildHomeScreen(
      PeopleProvider userProvider, StatisticsProvider statisticsProvider) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.0),
            Text('Welcome', style: TextStyle(fontSize: 16.0)),
            Text(
              userProvider.user.name,
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: RaisedButton(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) => RaiseIssue()));
                    },
                    child: SizedBox(
                      height: 80.0,
                      child: Center(
                        child: Text(
                          'Raise an issue',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 5,
                  child: RaisedButton(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) => TrackIssues()));
                    },
                    child: SizedBox(
                      height: 80.0,
                      child: Center(
                        child: Text(
                          'Track an issue',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _getOverallStatistics(statisticsProvider),
//                SizedBox(height: 16.0),
//                getOverallStatistics(statisticsProvider),
            SizedBox(height: 16.0),
            _getCurrentUserDashboard(userProvider)
          ],
        ),
      ),
    );
  }

  Widget getProfile() => UserProfileScreen();

  Widget getNotificationScreen() => Container(
        child: Center(
          child: Text("NOtification Screen"),
        ),
      );

  Widget _getOverallStatistics(StatisticsProvider statistics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Overall Statistics', style: TextStyle(fontSize: 16.0)),
        Divider(height: 10.0, thickness: 2.5),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Raised Issues',
                  content: statistics.overallStatistics.all_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Solved Issues',
                  content:
                      statistics.overallStatistics.solved_issues.toString()),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Pending Issues',
                  content:
                      statistics.overallStatistics.pending_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                title: 'Rejected Issues',
                content:
                    statistics.overallStatistics.rejected_issues.toString(),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getCurrentUserDashboard(var userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Your dashboard', style: TextStyle(fontSize: 16.0)),
        Divider(height: 10.0, thickness: 2.5),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Raised Issues',
                  content: userProvider.user.raised_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Solved Issues',
                  content: userProvider.user.solved_issues.toString()),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                  title: 'Pending Issues',
                  content: userProvider.user.pending_issues.toString()),
            ),
            Expanded(
              flex: 5,
              child: _dashboardWidget(
                title: 'Rejected Issues',
                content: userProvider.user.rejected_issues.toString(),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _dashboardWidget({String title, String content}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
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

  Widget _bottomNavbar() => BottomNavigationBar(
        selectedItemColor: Colors.blue,
        onTap: (int t) {
          setState(() {
            _currentScreenIndex = t;
          });
        },
        currentIndex: _currentScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.notifications),
//            title: Text('Notifications'),
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      );
}
