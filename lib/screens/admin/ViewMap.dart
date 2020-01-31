import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// ignore: must_be_immutable
class ViewMap extends StatefulWidget {
  LatLng latLng;

  ViewMap(this.latLng);

  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        initialCameraPosition:
        CameraPosition(target: widget.latLng, zoom: 12.0),
      ),
    );
  }
}
