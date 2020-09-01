import 'dart:io';

// Location package https://pub.dev/packages/location
import 'package:location/location.dart';

import 'package:location_tracker/Position.dart';

class PositionStore {
  var positions = <Position>[];

  add (Position position) => positions.add(position);

  int length() => positions.length;

  Position at(int i) => positions[i];

  read() {

  }

  write() {

  }

}  //end PositionStore class