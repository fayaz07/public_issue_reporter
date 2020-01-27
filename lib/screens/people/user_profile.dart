import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/people.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/people/people_data_provider.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // People.fetchUserData().then((Result result) {
    //   print(result.message);
    //   if (result.success && result.hasData)
    //     Provider.of<PeopleProvider>(context, listen: false).user = result.data;
    // });
  }

  Widget _buildProfile() {
    final user = Provider.of<PeopleProvider>(context).user;
    Map<String, dynamic> _buildElements = People.toJSON(user);
    _buildElements.forEach((f, h) {
      // print("$f" + ":" + "$h");
    });
    return SingleChildScrollView(
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Icon(
                Icons.person,
                size: MediaQuery.of(context).size.width * (10 / 100),
              ),
              radius: MediaQuery.of(context).size.width * (15 / 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _buildElements["name"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          // _buildListTile(Icon(Icons.person), _buildElements["name"]),
          _buildListTile(Icon(Icons.phone), _buildElements["phone"]),
          _buildListTile(Icon(Icons.home), _buildElements["address"]),
          // _buildListTile(Icon(Icons.phone), _buildElements["locality_id"]),
          _buildListTile(Icon(Icons.notification_important), "Pending Issues",
              ending: _buildCircularEnding(
                  _buildElements["pending_issues"], Colors.yellow)),
          _buildListTile(Icon(Icons.feedback), "Raised Issues",
              ending: _buildCircularEnding(
                  _buildElements["raised_issues"], Colors.yellowAccent)),

          _buildListTile(Icon(Icons.report_problem), "Rejected Issues",
              ending: _buildCircularEnding(_buildElements["rejected_issues"],
                  Colors.red.withOpacity(0.6))),

          _buildListTile(Icon(Icons.check), "Solved Issues",
              ending: _buildCircularEnding(_buildElements["solved_issues"],
                  Colors.green.withOpacity(0.7))),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: RaisedButton(
              color: Colors.white,
              onPressed: () {},
              child: Text(
                "Log Out",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w300),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildCircularEnding(dynamic value, Color color) {
    return Container(
      width: 50.0,
      height: 50.0,
      color: color,
      child: Center(
        child: Text(value.toString()),
      ),
    );
  }

  Widget _buildListTile(Widget leading, String datavValue, {Widget ending}) {
    return Container(
      width: MediaQuery.of(context).size.width * (70 / 100),
      height: MediaQuery.of(context).size.height * (10 / 100),
      child: ListTile(
        leading: leading,
        trailing: ending != null ? ending : SizedBox(),
        title: Text(datavValue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result>(
      future: People.fetchUserData(),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data.success && snapshot.data.hasData) {
                return _buildProfile();
              } else
                return Center(
                  child: Text(snapshot.data.message),
                );
            } else {
              /// Here goes Connection Error Code
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            break;
        }

        return Container();
      },
    );
  }
}
