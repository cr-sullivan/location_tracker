import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_tracker/Position.dart';
import 'package:location_tracker/PositionStore.dart';
import 'package:location_tracker/PositionWidget.dart';

// Location package https://pub.dev/packages/location
import 'package:location/location.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

String appTitle = 'Location Tracker v0.000';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var positionStore = PositionStore();
  int counter = 0;
  final biggerFont = const TextStyle(fontSize: 18.0);
  Location location = new Location();
  LocationData locationData;
  var isSpinning = false;  // Spinner shows when waiting for location data

  void _addButtonPressed() async {
    setState(() {
      isSpinning = true;
      build(context);
    });

    locationData = await _getLocationData();

    setState(()  {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counter++;
      //positionStore.insert(0, Position("${counter}", locationData.latitude,
      positionStore.insert(0, Position("", locationData.latitude,
          locationData.longitude, DateTime.now()));
    });

    positionStore.write();

    setState(() {
      isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: isSpinning ? Text("Please wait...") : Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Show Information',
            onPressed: () {
              _showInfoDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
            onPressed: () {
              _showDeleteDialog(Icons.clear);
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear All',
            onPressed: () {
              _showDeleteDialog(Icons.clear_all);
            },
          ),
        ],
      ),

      // body: ListView.builder(
      //     itemCount: positionStore.length() * 2,
      //     itemBuilder: (BuildContext context, int position) {
      //       if (position.isOdd) return Divider();
      //       final index = position ~/ 2;
      //       return _buildRow(index);
      //     }),

      // body: Column(
      //   children: [
      //     ListView.builder(
      //       itemCount: positionStore.length() * 2,
      //       itemBuilder: (BuildContext context, int position) {
      //         if (position.isOdd) return Divider();
      //         final index = position ~/ 2;
      //         return _buildRow(index);
      //       }),
      //   ],  //Children
      // ),

      body: buildListView(isSpinning),

      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonPressed,
        tooltip: 'Add location',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView buildListView(bool isSpinning) {
    return ListView.builder(
        itemCount: positionStore.length() * 2,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd)
            return Divider();
          if (isSpinning)
            return ListTile(title: SpinKitFadingCircle(
              color: Colors.red,
              size: 50.0,
            ));
          final index = position ~/ 2;
          return _buildRow(index);
        });
    }

  @override
  void initState() {
    super.initState();
    _initialiseLocationService();
    _loadData();
  }

  _loadData() async {
    PositionStore oldPositionStore = PositionStore();
    await oldPositionStore.read();
    setState(() {
      int count = oldPositionStore.length();
      for (int i = 0; i < count; i++) {
        positionStore.add(oldPositionStore.positions[i]);
      }
    });
  }

  Widget _buildRow(int i) {
    return ListTile(
      title: Text("${positionStore.at(i).getDescription()}" /*, style: _biggerFont*/),
      onTap: () {
        _pushMember(positionStore.at(i));
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(appTitle),
            content: Text('Flutter.\r\nwww.sullivanapps.co.nz'),
          );
        });
  }

  void _showDeleteDialog(IconData iconData) {
    String prompt = iconData == Icons.clear_all
        ? "Do you want to delete all the location data?"
        : "Do you want to delete the most recent (top) location data?";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete all data"),
          content: new Text(prompt),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (iconData == Icons.clear_all)
                  _clearAll();
                else
                  _clearFirst();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearFirst() {
    setState(()  {
      if (positionStore.length() > 0)
        positionStore.removeAt(0);
    });
    positionStore.write();
  }

  void _clearAll() {
    setState(()  {
      positionStore.clear();
    });
    positionStore.write();
  }

  _pushMember(Position position) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PositionWidget(position)));

    setState(() {
      // Force redraw after possible edit to comment
      position = Position(position.comment, position.latitude, position.longitude,
          position.dateTime);
    });

    positionStore.write();
  }

  _initialiseLocationService() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
  }

  Future<LocationData> _getLocationData() async {
    LocationData result = await location.getLocation();
    return result;
  }

}  //end class
