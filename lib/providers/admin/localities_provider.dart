import 'package:flutter/cupertino.dart';
import 'package:public_issue_reporter/data_models/locality.dart';

class LocalitiesProvider with ChangeNotifier {
  List<Locality> _localities = [];

  List<Locality> get localities => _localities;

  set localities(List<Locality> data) {
    _localities = data;
    notifyListeners();
  }

  removeLocalityById(int i){
    var ll = _localities;
    ll.removeAt(i);
    localities = ll;
  }

  removeLocality(Locality locality){
    var ll = _localities;
    ll.remove(locality);
    localities = ll;
  }
}
