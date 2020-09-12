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
  String comment;
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime dateTime;

  // Constants
  static final Month = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov', 'Dec'];

  Position(this.comment, this.latitude, this.longitude, this.accuracy, this.dateTime)  {
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

  String getAccuracyString() {
    return accuracy.toStringAsFixed(0) + "m";
  }

  String getDateTimeString() {
    String minutes = dateTime.minute.toString();
    if (minutes.length == 1) {
      minutes = "0" + minutes;  // Pad with 0 if < 10
    }
    return dateTime.day.toString() + Month[dateTime.month-1] + " " +
      dateTime.hour.toString() + ":" + minutes;
  }

  String getDescription() {
    return comment + " " + getDateTimeString() + " " + getLocationString();
  }

  //Note: you can convert the timestamp into a DateTime with:
  //DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt())

  // JSON encoding/decoding
  Position.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        accuracy = json['accuracy'] ?? 0,
        dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']);

  Map<String, dynamic> toJson() => {
    'comment' : comment,
    'latitude' : latitude,
    'longitude' : longitude,
    'accuracy' : accuracy,
    'dateTime' : dateTime.millisecondsSinceEpoch
  };

}  //End of Position class


