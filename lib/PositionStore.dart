import 'dart:convert';
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

  insert(int index, Position position) => positions.insert(index, position);

  int length() => positions.length;

  Position at(int i) => positions[i];

  clear() => positions.clear();

  removeAt(int index) => positions.removeAt(index);

  read() async {
      try {
        final file = await _localFile;
        String contents = await file.readAsString();
        print("read " + contents);

        // https://www.woolha.com/tutorials/dart-split-string-by-newline-using-linesplitter
        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(contents);

        for (int i=0; i < lines.length; i++) {
          String line = lines[i];
          Map positionMap = jsonDecode(line);
          Position position = Position.fromJson(positionMap);
          positions.add(position);
        }

      } catch (e) {
        // If encountering an error, return null.
        return null;
      }
  }

  write() async {
    // Build a string of all the json encoded positions.
    String allEncodedPositions = "";
    print("PositionStore.write");
    for (int i=0; i < positions.length; i++) {
      String encoded = jsonEncode(positions[i]);
      allEncodedPositions = allEncodedPositions + encoded + "\r\n";
      print("encoded: " + encoded);
    }

    print("Write: " + allEncodedPositions);
    final file = await _localFile;
    file.writeAsStringSync(allEncodedPositions, mode: FileMode.write, flush: true);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("_localFile " + path);
    return File('$path/LocationStore.txt');
  }

  // writePosition(Position position) {
  //   final file = _localFile;
  //   print("writing " + position.comment);
  //
  //   // Write the file.
  //   return file.writeAsStringSync(position.comment);
  // }
  //
  // Position readPosition()  {
  //   try {
  //     final file = _localFile;
  //
  //     // Read the file.
  //     String contents = file.readAsStringSync();
  //     print("read " + contents);
  //
  //     //return contents;  //int.parse(contents);
  //     Position result = Position(contents, 0, 0, DateTime.now());
  //     return result;
  //   } catch (e) {
  //     // If encountering an error, return null.
  //     return null;
  //   }
  // }


}  //end PositionStore class