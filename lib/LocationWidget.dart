import 'package:flutter/material.dart';
import 'package:location_tracker/Location.dart';

class LocationState extends State<LocationWidget> {
  final Location location;

  LocationState(this.location);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location.text),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          //Image.network(parish.avatarUrl),
          Text(location.text),
        ], ),
      ),
    );
  }
}

class LocationWidget extends StatefulWidget {
  final Location location;

  LocationWidget(this.location) {
    if (location == null) {
      throw ArgumentError(
          "location of MemberWidget cannot be null. Received: '$location'");
    }
  }

  @override
  createState() => LocationState(location);
}