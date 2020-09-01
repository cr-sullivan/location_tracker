// Location package https://pub.dev/packages/location
import 'package:location/location.dart';

// info.plist for ios  in  ios/runner  :
// <key>NSLocationWhenInUseUsageDescription</key>
// <string>Location Tracker needs Location permissions when in use.</string>
// <key>NSLocationAlwaysUsageDescription</key>
// <string>Location Tracker needs Location permissions always.</string>

class Position {
  String text;
  LocationData _locationData;

  Position(this.text)  {
    if (text == null) {
      throw ArgumentError("text of Position cannot be null. "
          "Received: '$text'");
    }

    //Note: you can convert the timestamp into a DateTime with:
    //DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt())

    //This works, but runs later
    // Future<LocationData> futureLocationData = _getLocationData();
    // futureLocationData.then((value)
    // {
    //   _locationData = value;
    //   text = _locationData.latitude.toString() + ", " +
    //       _locationData.longitude.toString();
    // });

    // The following does NOT work
    // List<Future<LocationData>> futureLocations = List();
    // futureLocations.add(futureLocationData);
    // Future.wait(futureLocations);

    // print("Waiting");
    // int i = 0;
    // while (_locationData == null) {
    //   //Busy wait
    //   i++;
    // }
    // print(text);

    //FutureBuilder

    _getLocation();
  }

  _getLocation() async {
    _locationData = await _getLocationData();
    text = _locationData.latitude.toString() + ", " +
        _locationData.longitude.toString();
  }

  Future<LocationData> _getLocationData() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData result = await location.getLocation();
    return result;
  }

}

