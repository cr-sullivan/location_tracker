import 'package:flutter/material.dart';
import 'package:location_tracker/Position.dart';

class PositionState extends State<PositionWidget> {
  final Position position;
  final biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController _controller = TextEditingController();

  PositionState(this.position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(position.comment),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          //Image.network(parish.avatarUrl),
          Text(position.comment, style: biggerFont),
          TextField(
            controller: _controller..text = position.comment,
            decoration: new InputDecoration(hintText: "Enter a comment"),
            onChanged: (String value) async {
              setState(() {
                position.comment = value;
              });
              // if (value != '13') {
              // return;
              // }
            },  // onChanged

            // onSubmitted: (String value) async {
            //   setState(() {
            //     position.comment = value;
            //   });
            //   // await showDialog<void>(
            //   //   context: context,
            //   //   builder: (BuildContext context) {
            //   //     return AlertDialog(
            //   //       title: const Text('Thanks!'),
            //   //       content: Text('You typed "$value".'),
            //   //       actions: <Widget>[
            //   //         FlatButton(
            //   //           onPressed: () {
            //   //             Navigator.pop(context);
            //   //           },
            //   //           child: const Text('OK'),
            //   //         ),
            //   //       ],
            //   //     );
            //   //   }, //builder
            //   // );  // showDialog
            // },  //onSubmitted
          ),

          Text("Date: " + position.getDateTimeString(), style: biggerFont),
          Text("Locn: " + position.getLocationString(), style: biggerFont),

          RaisedButton(
            onPressed: () {
              // The Yep button returns "Yep!" as the result.
              Navigator.pop(context, true);
            },
            child: Text('Ok'),
          )
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