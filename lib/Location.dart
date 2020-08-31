class Location {
  final String text;


  Location(this.text) {
    if (text == null) {
      throw ArgumentError("text of Location cannot be null. "
          "Received: '$text'");
    }
  }
}
