import 'package:flutter/material.dart';
import 'package:location_tracker/Position.dart';

class PositionState extends State<PositionWidget> {
  Position position;
  final biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController _controller = TextEditingController();

  PositionState(this.position);

  @override
  Widget build(BuildContext context) {
    // https://medium.com/@iamatul_k/flutter-handle-back-button-in-a-flutter-application-override-back-arrow-button-in-app-bar-d17e0a3d41f
    return WillPopScope (
      onWillPop: _onBackPressed,
      child: Scaffold(
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
              autofocus: true,
              decoration: new InputDecoration(hintText: "Enter a comment"),
              // onChanged: (String value) async {
              //   setState(() {
              //     position.comment = value;
              //   });
              // },  // onChanged

              onEditingComplete: () {
                setState(() {
                  // // Force redraw after possible edit to comment
                  // position = Position(position.comment, position.latitude, position.longitude,
                  //     position.dateTime);
                  position.comment = _controller.text;
                });
              },  // onEditingComplete

              onSubmitted: (String value) async {
                setState(() {
                  position.comment = value;
                });
                // await showDialog<void>(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: const Text('Thanks!'),
                //       content: Text('You typed "$value".'),
                //       actions: <Widget>[
                //         FlatButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           child: const Text('OK'),
                //         ),
                //       ],
                //     );
                //   }, //builder
                // );  // showDialog
              },  //onSubmitted
            ),

            Text("Date: " + position.getDateTimeString(), style: biggerFont),
            Text("Locn: " + position.getLocationString(), style: biggerFont),

            // RaisedButton(
            //   onPressed: () {
            //     // The Yep button returns "Yep!" as the result.
            //     Navigator.pop(context, true);
            //   },
            //   child: Text('Ok'),
            // )
          ], ),
        ),
      )
    );
  }

  Future<bool> _onBackPressed() {
    // return showDialog(
    //   context: context,
    //   builder: (context) => new AlertDialog(
    //     title: new Text('Are you sure?'),
    //     content: new Text('Do you want to exit an App'),
    //     actions: <Widget>[
    //       new GestureDetector(
    //         onTap: () => Navigator.of(context).pop(false),
    //         child: Text("NO"),
    //       ),
    //       SizedBox(height: 16),
    //       new GestureDetector(
    //         onTap: () => Navigator.of(context).pop(true),
    //         child: Text("YES"),
    //       ),
    //     ],
    //   ),
    // ) ??
    //     false;
    position.comment = _controller.text;
    return Future.value(true);
  }

}  //end class

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