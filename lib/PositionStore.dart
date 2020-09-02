import 'dart:io';

// Location package https://pub.dev/packages/location
// See https://flutter.dev/docs/cookbook/persistence/reading-writing-files
// See https://medium.com/flutter-community/serializing-your-object-in-flutter-ab510f0b8b47
import 'package:location/location.dart';

import 'package:location_tracker/Position.dart';
import 'package:path_provider/path_provider.dart';

class PositionStore {
  var positions = <Position>[];

  add (Position position) => positions.add(position);

  int length() => positions.length;

  Position at(int i) => positions[i];

  read() async {
    Position position = await readPosition();
    positions.add(position);
  }

  write() {
    positions.forEach((position) => writePosition(position));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/LocationStore.txt');
  }

  Future<File> writePosition(Position position) async {
    final file = await _localFile;
    print("writing " + position.comment);

    // Write the file.
    //return file.writeAsString(position.comment);
    return file.writeAsBytes(position.);
  }

  Future<Position> readPosition() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      print("read " + contents);

      //return contents;  //int.parse(contents);
      Position result = Position(contents, null);
      return result;
    } catch (e) {
      // If encountering an error, return null.
      return null;
    }
  }


}  //end PositionStore class