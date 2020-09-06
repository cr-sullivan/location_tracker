import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_tracker/Position.dart';

//https://pub.dev/packages/google_maps_flutter
// https://www.raywenderlich.com/4466319-google-maps-for-flutter-tutorial-getting-started
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionState extends State<PositionWidget> {
  Position position;
  final biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController _textEditingController = TextEditingController();

  // Google Maps
  Completer<GoogleMapController> _mapController = Completer();
  static CameraPosition _myLocation;
  List<Marker> markers = <Marker>[];

  PositionState(this.position) {
    _myLocation = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    getMarkers();

    // https://medium.com/@iamatul_k/flutter-handle-back-button-in-a-flutter-application-override-back-arrow-button-in-app-bar-d17e0a3d41f
    return WillPopScope (
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(position.comment),
        ),

        // body: Column(
        //   children: [
        //     GoogleMap(
        //       initialCameraPosition: _myLocation,
        //       mapType: MapType.normal,
        //       onMapCreated: (GoogleMapController controller) {
        //         _mapController.complete(controller);
        //       },
        //     ),
        //   ], //children
        // ),

        // // This works
        // body: GoogleMap(
        //   initialCameraPosition: _myLocation,
        //   mapType: MapType.normal,
        //   onMapCreated: (GoogleMapController controller) {
        //     _mapController.complete(controller);
        //   },
        // ),

          // // This crashes
          // body: Column(
          //   children: <Widget> [
          //     Text("Start"),
          //     GoogleMap(
          //       initialCameraPosition: _myLocation,
          //       mapType: MapType.normal,
          //       onMapCreated: (GoogleMapController controller) {
          //         _mapController.complete(controller);
          //       },
          //     ),
          //
          //     Text("Hello"),
          //   ],
          // )

        // This Works but overlays the children on top of each other
        body: Stack(
          children: <Widget> [
            GoogleMap(
              initialCameraPosition: _myLocation,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              markers: Set<Marker>.of(markers),
            ),

            Column(
              children: [
                Text("Start"),
                Text("end"),
              ],
            ),

          ],
        )

      ),
    );

  }

  void getMarkers() {
    markers.clear();
    markers.add(
        Marker(
          markerId: MarkerId("location"),
          position: LatLng(position.latitude, position.longitude),
          // infoWindow: InfoWindow(
          //     title: places[i].name, snippet: places[i].vicinity),
          onTap: () {},
        ),
    );
  }  //build

  @override
  Widget buildIt(BuildContext context) {
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
              // or leText(position.comment, style: biggerFont),
              TextField(
                controller: _textEditingController..text = position.comment,
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
                    position.comment = _textEditingController.text;
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

              // Column(
              //   children: [
              //     GoogleMap(
              //       initialCameraPosition: _myLocation,
              //       mapType: MapType.normal,
              //       onMapCreated: (GoogleMapController controller) {
              //         _mapController.complete(controller);
              //       },
              //     ),
              //   ], // children
              // ),

              Scaffold(
                body: GoogleMap(
                  initialCameraPosition: _myLocation,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                ),
              ),

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
  }  //build

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
    position.comment = _textEditingController.text;
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