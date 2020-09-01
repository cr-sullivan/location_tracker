// Location package https://pub.dev/packages/location
import 'package:location/location.dart';


// info.plist for ios  in  ios/runner  :
// <key>NSLocationWhenInUseUsageDescription</key>
// <string>Location Tracker needs Location permissions when in use.</string>
// <key>NSLocationAlwaysUsageDescription</key>
// <string>Location Tracker needs Location permissions always.</string>

class Position {
  final String text;
  final LocationData locationData;

  Position(this.text, this.locationData)  {
    if (text == null) {
      throw ArgumentError("text of Position cannot be null. "
          "Received: '$text'");
    }
  }

  String getLocationString() {
    if (locationData == null) {
      return "Unknown location";
    } else {
      return locationData.latitude.toString() + ", " +
           locationData.longitude.toString();
    }
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

    //_getLocation();

}  //End of Position class


