import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/providers/admin/admin_provider.dart';
import 'package:public_issue_reporter/providers/admin/localities_provider.dart';
import 'package:public_issue_reporter/providers/issues_provider.dart';
import 'package:public_issue_reporter/providers/statistics_provider.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';
import 'package:public_issue_reporter/screens/people/people_home.dart';
import 'login/splash.dart';

void main() {
  //The app execution starts from here
  runApp(PublicIssueReporter());
}

class PublicIssueReporter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PeopleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StatisticsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalitiesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IssuesProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.greenAccent),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
