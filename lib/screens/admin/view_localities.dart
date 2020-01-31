import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/locality.dart';
import 'package:public_issue_reporter/data_models/result.dart';
import 'package:public_issue_reporter/providers/admin/localities_provider.dart';
import 'package:public_issue_reporter/utils/configs.dart';
import 'package:public_issue_reporter/utils/widgets.dart';

class ViewLocalities extends StatefulWidget {
  @override
  _ViewLocalitiesState createState() => _ViewLocalitiesState();
}

class _ViewLocalitiesState extends State<ViewLocalities> {
  @override
  void initState() {
    super.initState();

    Locality.getLocalities().then((Result result) {
      if (result.success)
        Provider.of<LocalitiesProvider>(context, listen: false).localities =
            result.data;
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localities = Provider.of<LocalitiesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Localities')),
      body: _getBody(localities),
    );
  }

  Widget _getBody(LocalitiesProvider localitiesProvider) {
    return localitiesProvider.localities.length > 0
        ? ListView.builder(
            itemCount: localitiesProvider.localities.length,
            itemBuilder: (BuildContext context, int i) =>
                _locality(localitiesProvider.localities[i], localitiesProvider),
          )
        : Configs.loader;
  }

  Widget _locality(Locality locality, LocalitiesProvider localitiesProvider) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${locality.name}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Added on: ${getDateTime(locality.added_on)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Locality Admin: ${locality.additional_data == null ? 'Not assigned' : locality.additional_data.name} ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.0),
            FlatButton(
              onPressed: () {
                localitiesProvider.removeLocality(locality);
                Locality.deleteLocality(locality.locality_id);
              },
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text('Remove'),
                ),
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
