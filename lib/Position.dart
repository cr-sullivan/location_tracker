// Location package https://pub.dev/packages/location
import 'dart:io';

import 'package:location/location.dart';


// info.plist for ios  in  ios/runner  :
// <key>NSLocationWhenInUseUsageDescription</key>
// <string>Location Tracker needs Location permissions when in use.</string>
// <key>NSLocationAlwaysUsageDescription</key>
// <string>Location Tracker needs Location permissions always.</string>

class Position {
  final String comment;
  final LocationData locationData;
  final Month = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov', 'Dec'];
  final DateTime dateTime = DateTime.now();

  Position(this.comment, this.locationData)  {
    if (comment == null) {
      throw ArgumentError("text of Position cannot be null. "
          "Received: '$comment'");
    }
  }

  String getLocationString() {
    if (locationData == null) {
      return "Unknown location";
    } else {
      // Round to 5 decimal places for 1m precision at equator
      // https://gisjames.wordpress.com/2016/04/27/deciding-how-many-decimal-places-to-include-when-reporting-latitude-and-longitude/
      return locationData.latitude.toStringAsFixed(5) + ", " +
           locationData.longitude.toStringAsFixed(5);
    }
  }

  String getDateTimeString() {
    if (locationData == null) {
      return "";
    } else {
       //DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt());
       //return locationData.time.toString();
       //return dateTime.toIso8601String();
       //return dateTime.toString();
      return dateTime.day.toString() + Month[dateTime.month-1] + " " +
         dateTime.hour.toString() + ":" + dateTime.minute.toString();
    }
  }

  String getDescription() {
    return comment + " " + getDateTimeString() + " " + getLocationString();
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


