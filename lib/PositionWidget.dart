import 'package:flutter/material.dart';
import 'package:location_tracker/Position.dart';

class PositionState extends State<PositionWidget> {
  final Position position;

  PositionState(this.position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(position.text),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          //Image.network(parish.avatarUrl),
          Text(position.text),
          //if (position.)
        ], ),
      ),
    );
  }
}

class PositionWidget extends StatefulWidget {
  final Position position;

  PositionWidget(this.position) {
    if (position == null) {
      throw ArgumentError(
          "location of MemberWidget cannot be null. Received: '$position'");
    }
  }

  @override
  createState() => PositionState(position);
}