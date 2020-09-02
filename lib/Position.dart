import 'dart:io';
import 'dart:convert';

// Location package https://pub.dev/packages/location
import 'package:location/location.dart';


// info.plist for ios  in  ios/runner  :
// <key>NSLocationWhenInUseUsageDescription</key>
// <string>Location Tracker needs Location permissions when in use.</string>
// <key>NSLocationAlwaysUsageDescription</key>
// <string>Location Tracker needs Location permissions always.</string>

class Position {
  // Fields
  final String comment;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  // Constants
  final Month = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov', 'Dec'];

  Position(this.comment, this.latitude, this.longitude, this.dateTime)  {
    if (comment == null) {
      throw ArgumentError("text of Position cannot be null. "
          "Received: '$comment'");
    }

    // int millisecondsSinceEpoch = dateTime.millisecondsSinceEpoch;
    // var dt = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    String encoded = jsonEncode(this);
    print("encoded: " + encoded);
  }

  String getLocationString() {
    if (latitude == 0 && longitude == 0) {
      return "Unknown location";
    } else {
      // Round to 5 decimal places for 1m precision at equator
      // https://gisjames.wordpress.com/2016/04/27/deciding-how-many-decimal-places-to-include-when-reporting-latitude-and-longitude/
      return latitude.toStringAsFixed(5) + ", " + longitude.toStringAsFixed(5);
    }
  }

  String getDateTimeString() {
    return dateTime.day.toString() + Month[dateTime.month-1] + " " +
      dateTime.hour.toString() + ":" + dateTime.minute.toString();
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

  // JSON encoding/decoding
  Position.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']);

  Map<String, dynamic> toJson() => {
    'comment' : comment,
    'latitude' : latitude,
    'longitude' : longitude,
    'dateTime' : dateTime.millisecondsSinceEpoch
  };

}  //End of Position class


